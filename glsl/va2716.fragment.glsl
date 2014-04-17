//Conway's Game of Life variation
//By: Flyguy

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

vec3 dead = vec3(0);
vec3 gol = vec3(0,1,0);

vec2 rmouse = vec2(0);

vec3 getcell()
{
	return texture2D(backbuffer,position).xyz;
}

vec3 getcell(float ox,float oy)
{
	return texture2D(backbuffer,(position+vec2(ox,oy))/resolution.xy ).xyz;
}

int neighbors(vec3 color)
{
	int i = 0;
	//Left/Right/Up/Down
	if(getcell(-1.0,0.0) == color)
	{
		i++;
	}
	if(getcell(1.0,0.0) == color)
	{
		i++;
	}
	if(getcell(0.0,-1.5) == color)
	{
		i++;
	}
	if(getcell(0.0,1.0) == color)
	{
		i++;
	}
	//Diagonals
	if(getcell(-1.0,-1.0) == color)
	{
		i++;
	}
	if(getcell(1.0,-1.0) == color)
	{
		i++;
	}
	if(getcell(1.0,1.0) == color)
	{
		i++;
	}
	if(getcell(-1.0,1.0) == color)
	{
		i++;
	}
	return i;
}

float rand(vec2 co){
    float v = fract(sin(dot(co.xy+time ,vec2(12.9898,78.233))) * 43758.5453+time);
	if(v>0.5) return 1.0;
	else return 0.0;
}

//B456S2478

vec2 lmouse = vec2(0); 

void main( void ) 
{
	lmouse = rmouse;
	
	rmouse = mouse * resolution.xy;

	position = gl_FragCoord.xy;//( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;

	int n1 = neighbors(gol);

	
	if(distance(position,rmouse) < 16.0)
	{
		gl_FragColor = vec4( gol, 1.0 );
	}
	
	//Survives if there are 2,4,7,or 8 neighbors
	if(( n1 == 2 || n1 == 4|| n1 == 7|| n1 == 8 )&& getcell() == gol)
	{
		gl_FragColor = vec4( vec3( gol ), 1.0 );
	}
	else
	{
		if(getcell() == gol)
		{	
			gl_FragColor = vec4( dead, 1.0 );
		}
	}
	//Born if there are 4,5,or 6 neighbors
	if(( n1 == 4 || n1 == 5 || n1 == 6 && getcell() == dead))
	{
		gl_FragColor = vec4( gol, 1.0 );
	}
	//gl_FragColor = vec4( vec3(rand(position)), 1.0 );
}
