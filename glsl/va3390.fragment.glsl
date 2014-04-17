//Conway's Game of Life
//By: Flyguy

//Old shader I made, now works properly.

//Now uses alpha to determine the state of a cell instead of color.

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

vec4 dead = vec4(0);
vec4 alive = vec4(0,1,0,1);

vec3 hsv2rgb(float h,float s,float v) {
	return mix(vec3(1.),clamp((abs(fract(h+vec3(3.,2.,1.)/3.)*6.-3.)-1.),0.,1.),s)*v;
}

bool rand(vec2 co){
    float v = fract(sin(dot(co.xy+time ,vec2(12.9898,78.233))) * 43758.5453+time);
    return (v>0.5);
}

vec3 background()
{
	vec3 col = vec3(0.15);
	
	if(mod(position.x,8.0) < 1.0 || mod(position.y,8.0) < 1.0)
	{
		col = vec3(0.17);
	}
	
	if(mod(position.x,16.0) < 1.0 || mod(position.y,16.0) < 1.0)
	{
		col = vec3(0.2);
	}
	
	return col;
}

vec4 getcell()
{
	return texture2D(backbuffer,position/resolution.xy);
}

vec4 getcell(float ox,float oy)
{
	return texture2D(backbuffer,mod((position+vec2(ox,oy)),resolution)/resolution.xy );
}

int neighbors(vec4 color)
{
	int i = 0;
	//Left/Right/Up/Down
	if(getcell(-1.0,0.0).w == color.w)
	{
		i++;
	}
	if(getcell(1.0,0.0).w == color.w)
	{
		i++;
	}
	if(getcell(0.0,-1.0).w == color.w)
	{
		i++;
	}
	if(getcell(0.0,1.0).w == color.w)
	{
		i++;
	}
	//Diagonals
	if(getcell(-1.0,-1.0).w == color.w)
	{
		i++;
	}
	if(getcell(1.0,-1.0).w == color.w)
	{
		i++;
	}
	if(getcell(1.0,1.0).w == color.w)
	{
		i++;
	}
	if(getcell(-1.0,1.0).w == color.w)
	{
		i++;
	}
	return i;
}

//B3S23

void main( void ) 
{
	position = gl_FragCoord.xy;
	
	vec4 endColor = vec4(background(),dead.w);
	
	int n1 = neighbors(alive);
	
	vec4 curCell = getcell();
	
	alive = vec4(vec3(hsv2rgb(distance(mouse,position/resolution),0.5,1.0)),alive.w);
			
	//Right click and drag to change brush size.
	if(distance(position,mouse*resolution) < surfaceSize.x*16.0)
	{
		if(rand(position))
		{
			endColor = alive;
		}
		else
		{
			endColor = vec4(background(),dead.w);	
		}
	}
	else
	{
		endColor = vec4(background(),dead.w);
	}
	
	
	//Survives if n1 is equal to any of the following values
	if(( n1 ==2 || n1 == 3 )&& curCell.w == alive.w)
	{
		endColor = alive;
	}
	else
	{
		if(curCell.w == alive.w)
		{	
			endColor = vec4(background(),dead.w);
		}
	}
	
	//Born if n1 is equal to any of the following values
	if(( n1 == 3 )&& curCell.w != alive.w)
	{
		endColor = alive;
	}
	
	gl_FragColor = endColor;
}