//Conway's Game of Life
//By: Flyguy

//Old shader I made, now works properly.

//Now uses alpha to determine the state of a cell instead of color.

//Cells now have a color to make it possible to distinguish between generations of cells
//Stepped color to make it easier to visualize the merging of two populations (averaged color)

// Performance tweaked by Kabuto (removed most of the decisions which are pretty expensive on GPUs)

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;
uniform vec2 surfaceSize;

varying vec2 surfacePosition;

vec2 position = vec2(0);

bool rand(vec2 co){
	// not truly random but random enough
    return fract(time+co.x*.6535166+co.y*.461345423)*fract(time*.23542346+co.x*.38315+co.y*.24467155) < .05;
}

vec3 background()
{
	return vec3(
		0.15 +
		0.02 * max(0.,1.5-min(mod(position.x,8.0),mod(position.y,8.0))) +
		0.03 * max(0.,1.5-min(mod(position.x,16.0),mod(position.y,16.0)))
	);
}

vec4 getcell()
{
	return texture2D(backbuffer,position/resolution.xy);
}

// Returns the previous generation's cell color at the given offset. rgb = color, w = 1 for alive or 0 for dead. rgb zeroed out for dead cells.
vec4 getcell(float ox,float oy)
{
	vec4 color = texture2D(backbuffer,mod((position+vec2(ox,oy)),resolution)/resolution.xy );
	return color*color.w;
}

// Simply adds all the neighbours
vec4 neighbors()
{
	return
		  getcell(-1.0,-1.0)
		+ getcell(-1.0, 0.0)
		+ getcell(-1.0, 1.0)
		+ getcell( 0.0,-1.0)
		+ getcell( 0.0, 1.0)
		+ getcell( 1.0,-1.0)
		+ getcell( 1.0, 0.0)
		+ getcell( 1.0, 1.0);
}

void main( void ) 
{
	position = gl_FragCoord.xy;
	
	vec4 endColor;
	
	vec4 nb1 = neighbors();
	
	vec4 curCell = getcell();
			
	//Right click and drag to change brush size.
	if(distance(position,mouse*resolution) < surfaceSize.x*16.0 && rand(position))
	{
		// Rainbow colors, hue depending on time
		endColor = vec4(abs(fract(vec3(0.,0.33,0.66)+time*.1)-.5)*2.,1.0);
	}
	else
	{
		// For cells that are to be alive new color is the average of their living neighbours' colors
		float metric = nb1.w * 2. + curCell.w;
		endColor = metric >= 5. && metric <= 7. ? nb1/nb1.w : vec4(background(),0.);
	}

	gl_FragColor = endColor;
}