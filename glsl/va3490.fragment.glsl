//@ME

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float PI = 3.1415926535;
const float TWOPI = PI*2.0;
const mat2 m = mat2( 0.80,  0.60, -0.60,  0.80 );

vec2 rotate(vec2 point, float rads) {
	float cs = cos(rads);
	float sn = sin(rads);
	return point * mat2(cs, -sn, sn, cs);
}

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
    f += 0.5000*noise( p ); p = m*p*2.02;
    f += 0.25000*noise( p ); p = m*p*2.03;
    f += 0.12500*noise( p ); p = m*p*2.01;
    f += 0.06250*noise( p ); p = m*p*2.04;
    f += 0.03125*noise( p );
    return f/0.984375;
}

float curve( float x)
{
	return smoothstep( 0.8+sin(time)*0.15, 0.0, cos(x*PI) );
}

float thing(vec2 pos) 
{
	vec2 p = vec2(pos + fbm(pos) * 0.5);
	float offset = -curve(p.y) * 0.5 * sin(time * 0.25);
	float row = floor((p.y)/2.0);
	if (mod(row, 2.0) < 1.0)
		offset = curve(p.y) * 0.5;
	
	float a = curve(p.x + offset);
	float b = curve(p.y);
	float c = (a + b) * (sqrt(a+b));
	float f = (a * b) * (sqrt(a+b)) * (dot(a,b) * offset * sin(time));
	return smoothstep(1.0, -c, f);
}

void main(void) 
{
	vec2 position = ( gl_FragCoord.xy / resolution );
	vec2 world = position * 10.-5.;
	world.x *= resolution.x / resolution.y;
	float dist = 1.-thing(world);

	gl_FragColor = vec4( dist, dist, dist, 1.0 );
}
