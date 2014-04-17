//Conway's Game of Life
//By: Flyguy

//Old shader I made, now works properly.

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
	return texture2D(backbuffer,position/resolution.xy).xyz;
}

vec3 getcell(float ox,float oy)
{
	return texture2D(backbuffer,mod((position+vec2(ox,oy)),resolution)/resolution.xy ).xyz;
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
	if(getcell(0.0,-1.0) == color)
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

bool rand(vec2 co){
    float v = fract(sin(dot(co.xy+time ,vec2(12.9898,78.233))) * 43758.5453+time);
	if(v>0.5) return true;
	else return false;
}

//B3S23

vec3 endColor = vec3(0);

void main( void ) 
{
	rmouse = mouse * resolution.xy;

	position = gl_FragCoord.xy;

	int n1 = neighbors(gol);

	//Right click and drag to change brush size.
	if(distance(position,rmouse) < surfaceSize.x+16.0)
	{
		if(rand(position))
		{
			endColor = gol;
		}
	}
	else
	{
		endColor = dead;
	}
	
	
	//Survives if n1 is equal to any of the following values
	if(( n1 ==2|| n1 == 3 )&& getcell() == gol)
	{
		endColor = gol;
	}
	else
	{
		if(getcell() == gol)
		{	
			endColor = getcell()*0.25;
		}
	}
	
	//Born if n1 is equal to any of the following values
	if(( n1 == 3 && getcell() != gol))
	{
		endColor = gol;
	}
	
	gl_FragColor = vec4(endColor,1.0);
}
