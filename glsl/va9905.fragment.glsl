#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
varying vec2 surfacePosition;

float sdBox( vec2 p, float b )
{
  vec2 d = abs(p) - b;
  return min(max(d.x,d.y),0.0) +
         length(max(d,0.0));
}

float circle (vec2 p, float r)
{
	return length(p) - r;	
}

float hash( float n )
{
    return fract(sin(n)*43758.5453123);
}

vec3 hash3( float n )
{
    return fract(sin(vec3(n,n+1.0,n+2.0))*vec3(43758.5453123,22578.1459123,19642.3490423));
}

float noise( in vec2 x )
{
    vec2 p = floor(x);
    vec2 f = fract(x);

    f = f*f*(3.0-2.0*f);

    float n = p.x + p.y*157.0;

    return mix(mix( hash(n+  0.0), hash(n+  1.0),f.x),
               mix( hash(n+157.0), hash(n+158.0),f.x),f.y);
}

const mat2 m2 = mat2( 0.80, -0.60, 0.60, 0.80 );

float fbm( vec2 p )
{
    float f = 0.0;

    f += 0.5000*noise( p ); p = m2*p*2.02;
    f += 0.2500*noise( p ); p = m2*p*2.03;
    f += 0.1250*noise( p ); p = m2*p*2.01;
    f += 0.0625*noise( p );

    return f/0.9375;
}

void main( void ) {

	vec2 p = surfacePosition*20.0;

	float d = 1.0;//sdBox(p, 0.5);
	float s = 1.0;
	
	for (int i = 0; i < 5; i++) {
		d += fbm(p+fbm(vec2(time, d)+p));
		p = abs(p - s);
		d = max(-d, circle(p, s)+sdBox(p, d-s));
		s *= 1.5;
	}

	gl_FragColor = vec4( sin(d)*.5+.5 );

}