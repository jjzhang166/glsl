#ifdef GL_ES
precision mediump float;
#endif 

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D bb;

const float ir = 3.0;
const float or = 8.0;

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
	return (get(p).w*(smoothstep(ir,ir+1.,l)*smoothstep(or,or-1.,l)));		
}

float kernel(vec2 p)
{
	float w = 0.0;
	for(float y = -or;y < or;y++)
	{
		for(float x = -or;x < or;x++)
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

vec3 init(vec2 p)
{
	vec3 fc;
	for(float i = 0.;i < 64.;i++)
	{
		vec2 rp = vec2(rand(vec2(i)),rand(vec2(-i)))*resolution;
		fc = (distance(rp,p) < or) ? vec3(1) : vec3(0);
	}
	return fc;
}
void main( void ) {

	vec2 p = ( gl_FragCoord.xy );

	float c = get(p).w;

	float k = kernel(p);
	
	if(k > 0.365 && k < 0.549)
	{
		c += k;
	}
	else
	{
		c -= k*.8;
	}
	
	if(length(mouse*resolution-p) < 12. && length(mouse*resolution-p) > 5. )
	{
		c = 1.-randb(p+time);
	}
	if(length(mouse) < 0.02 || time < 0.2)
	{
		c = 0.0;
	}
	
	gl_FragColor = vec4( vec3( 0 , k, c), c );

}