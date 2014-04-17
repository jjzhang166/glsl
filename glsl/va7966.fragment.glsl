#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float PI = 3.14159265358979323846264;
mat2 m = mat2( 0.8,  0.6, -0.6, 0.8 );
              
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

    float res = mix(mix( hash(n + 0.0), hash(n + 1.0), f.x),mix( hash(n+ 57.0), hash(n+ 58.0),f.x), f.y);
    return res;
}

float fbm( vec2 p )
{
    float f = 0.0;
    f += 0.5000*noise( p ); p = m*p*2.02;
    f += 0.2500*noise( p ); p = m*p*2.03;
    f += 0.1250*noise( p ); p = m*p*2.01;
    f += 0.0625*noise( p ); p = m*p*2.04;
    return f/0.9375;
}

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void main( void ) {

	vec2 pos = ( gl_FragCoord.xy / resolution.xy );

	float f = fbm( (pos* 10.0 + sin(time)) );
	float r = rand( (pos* 10.0 + sin(time)) );
	float v = r;
	gl_FragColor = vec4(v, v, v, 1.0);
}