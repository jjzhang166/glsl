#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

//Kernel radius
#define KERNEL 3.0 

float rand(vec2 co){
    return (fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453) > 0.5) ? 1.0 : 0.0;
}

vec4 cell(vec2 p)
{
	return texture2D(backbuffer,p/resolution);	
}

float neighbors(vec2 p,float cur)
{
	float n = 0.0;
	for(float x = -KERNEL;x <= KERNEL;x++)
	{
		for(float y = -KERNEL;y <= KERNEL;y++)
		{
			n += cell(p+vec2(x,y)).a;
		}
	}
	return n-cur;//If the current cell is alive, remove it from the living neighbors.
}

void main( void ) {
	
	vec2 m = mouse*resolution;

	vec2 p = gl_FragCoord.xy;

	float lastcell = cell(p).a;
	float curcell;
	
	float n = neighbors(p,lastcell);
	
	curcell = (distance(m,p) < 16.) ? rand(p+mod(time,10.0)) : lastcell;
	
	if(lastcell == 1.0)
	{
		if(n >= 10.0 && n <= 20.0) //Survival range
		{
			curcell = 1.0;
		}
		else
		{
			curcell = 0.0;
		}
	}
	else
	{
		if(n >= 6.0 && n <= 6.0) //Birth range
		{
			curcell = 1.0;
		}
	}
	
	gl_FragColor = vec4( vec3( curcell + lastcell), curcell );//Store cell state in alpha.
}