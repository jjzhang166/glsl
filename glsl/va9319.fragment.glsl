//Thematica: fractal13 12 juin 2013
//based  on http://glsl.heroku.com/e#9283.0

// resatiate.com
// based on http://www.fractalforums.com/new-theories-and-research/very-simple-formula-for-fractal-patterns/

#define N 25
#define pi 3.1415926535
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


// thanks http://glsl.heroku.com/e#5654.6
float cabs (const vec2 c) { return dot(c,c); }
vec2 cconj(const vec2 c) { return vec2(c.x, -c.y); }
vec2 cmul(const vec2 c1, const vec2 c2)
{
	return vec2(
		c1.x * c2.x - c1.y * c2.y,
		c1.x * c2.y + c1.y * c2.x
	);
}
vec2 cdiv(const vec2 c1, const vec2 c2)
{
	return cmul(c1, cconj(c2)) / dot(c2, c2);
}
vec3 Hue(float H)
{
	H *= 6.;
	return clamp(vec3(
		abs(H - 3.) - 1.,
		2. - abs(H - 2.),
		2. - abs(H - 4.)
	), 0., 1.);
}
vec3 HSVtoRGB(float h, float s, float v)
{
    return ((Hue(h) - 1.) * s + 1.) * v;
}
//
float wave(float t) { return .8 -.5 * abs(cos(t)); }

float fractal(vec2 z, vec2 c, float m, float color)
{	
	for ( int i = 0; i < N; i++ ){
		m = cabs(cmul(z, c));		
		z = abs(z / c)/(dot(m, pi)) + dot(c ,0.8*z);		
		color += exp(-cabs(c/z) );
		color += exp(-pi/cabs(z *z -c*c*pi));	
	}
	return color;
}

void main( void ) {	
	vec2 position=2.0*(gl_FragCoord.xy/resolution.xy)-1.0;
	position.x*=resolution.x/resolution.y;
	vec2 z =0.7* position;
	vec2 c = vec2( 0.01, 0.01 );
	c -=  vec2(wave(time*0.1 )+0.25, wave(time*0.1 )+0.25);
	float color =fractal(z, c, 0., 100.0)*0.3;
	vec3 ccc=HSVtoRGB(wave(color*8.5),wave(color*10.5),wave(color *12.1));	
	gl_FragColor = vec4(ccc, 1.0);}
