#ifdef GL_ES
precision mediump float;
#endif 

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D bb;

const float ir = 6.;
const float or = 12.0;

#define LOOP 

float pi = 3.14159;

vec4 get(vec2 p)
{
	#ifdef LOOP
	return texture2D(bb,mod(p/resolution,1.));	
	#else
	return texture2D(bb,p/resolution);
	#endif
}

float weight(vec2 p,float l)
{
	return (get(p).w*((1.-sin(l*.54))*exp(-l*0.2818)*(1./.355)/.425));		
}

float kernel(vec2 p)
{
	float w = 0.0;
	for(float y = -or;y <= or;y++)
	{
		for(float x = -or;x <= or;x++)
		{
			w += weight(p+vec2(x,y),length(vec2(x,y)));
		}
	}
	return w/((pi*or*or)-(pi*ir*ir));
}

float randb(vec2 co){
    return (fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453) > 0.75) ? 1.0 : 0.0;
}

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void main( void ) {

	vec2 p = ( gl_FragCoord.xy );

	float c = get(p).w;
	float kl = get(p).z;
	float k = kernel(p);
	
	if(k > 0.332 && k < 0.47)
	{
		c += k;
	}
	else
	{
		c -= k;
	}
	
	if(k > 0.346 && k < 0.37)
	{
		c += k;	
	}
	
	if(length(mouse*resolution-p) < 16. && length(mouse*resolution-p) > 3. )
	{
		c = 1.-randb(p+time);
	}
	if(length(mouse) < 0.02 || time < 0.2)
	{
		c = 0.0;
		if(length(p-resolution/2.) < 256.)
		{
			c = 1.-randb(p+time);
		}
		
	}
	
	gl_FragColor = vec4( vec3( 0 , c, k), c );

}