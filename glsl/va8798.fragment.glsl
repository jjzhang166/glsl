#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

//Kernel radius
#define KERNEL 1.0 

//#define ROUND_KERNEL
//#define LOOP_EDGE

float rand(vec2 co){
    return (fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453) > 0.5) ? 1.0 : 0.0;
}

vec4 cell(vec2 p)
{
	#ifdef LOOP_EDGE
	p = mod(p,resolution);
	#endif
	return texture2D(backbuffer,p/resolution);	
}

float neighbors(vec2 p,float cur)
{
	float n = 0.0;
	for(float x = -KERNEL;x <= KERNEL;x++)
	{
		for(float y = -KERNEL;y <= KERNEL;y++)
		{
			#ifdef ROUND_KERNEL
			if(length(vec2(x,y))<=KERNEL)
			{
				n += floor(cell(p+vec2(x,y)).a);
			}
			#else
			n += floor(cell(p+vec2(x,y)).a);
			#endif
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
	
	if(lastcell > 0.0)
	{
		curcell = lastcell-(1./6.); //Dead cells decay over 6 generations.	
	}
	if(lastcell == 1.0)
	{
		if(n >= 3.0 && n <= 6.0) //Survival range
		{
			curcell = 1.0;
		}
	}

	if(lastcell == 0.0)
	{
		if(n == 2.0 || n == 7.0 || n == 8.0) //Birth range
		{
			curcell = 1.0;
		}
	}
	
	gl_FragColor = vec4( vec3( curcell,curcell*0.5,0 )+(n/8.), curcell );//Store cell state in alpha.
}