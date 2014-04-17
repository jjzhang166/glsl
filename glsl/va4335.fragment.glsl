#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define RGB(r,g,b) vec3(r/255.,g/255.,b/255.)
#define PI 3.14159

float hash( float n );
float noise( in vec2 x );
float fbm( vec2 p );

vec3 grad(float v)
{
	float interp = sin(v*PI/2.0);
	
	interp = clamp(interp,0.0,1.0);
	
	vec3 c = vec3(0);
	
	vec3 c1 = RGB(255.,255.,255.);
	vec3 c2 = RGB(0.,157.,255.);
	vec3 c3 = RGB(0.,0.,0.);
	vec3 c4 = RGB(91.,200.,00.);
	
	c = mix(c2,c4,interp);
	
	c = mix(c,c3,interp*0.9);
	c = mix(c1,c,interp*1.1);
	
	return c;
}

void main( void ) {

	vec2 p = ( gl_FragCoord.xy / resolution.xy );

	float color = fbm(p*8.0);
	if(p.y < 8./resolution.y)
	{
		color = p.x;
	}


	gl_FragColor = vec4( vec3( grad(color) ), 1.0 );

}

mat2 m = mat2( 0.80,  0.60, -0.60,  0.80 );

/* Noise functions taken from #3240.0 */

float hash( float n )
{
    return fract(sin(n)*43758.5453);
}

float noise( in vec2 x )
{
    vec2 p = floor(x);
    vec2 f = fract(x);
    f = f*f*(3.0-2.0*f);
    float n = p.x + p.y*57.0;
    float res = mix(mix( hash(n+  0.0), hash(n+  1.0),f.x), mix( hash(n+ 57.0), hash(n+ 58.0),f.x),f.y);
    return res;
}

float fbm( vec2 p )
{
    float f = 0.0;
    f += 0.50000*noise( p -time); p = m*p*2.02;
    f += 0.25000*noise( p +time); p = m*p*2.03;
    f += 0.12500*noise( p +time); p = m*p*2.01;
    f += 0.06250*noise( p -time); p = m*p*2.04;
    f += 0.03125*noise( p +time);
    return f/0.984375;
}