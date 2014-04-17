// resatiate.com
// based on http://www.fractalforums.com/new-theories-and-research/very-simple-formula-for-fractal-patterns/
#define N 25
#define pi 3.1415926535
#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
varying vec2 surfacePosition;

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
float wave(float t) { return .5 - .5 * cos(t); }

float fractal(vec2 z, vec2 c, float m, float color)
{	
	for ( int i = 0; i < N; i++ ){
		m = cabs(cmul(z, c));
		
		vec2 zo = z;
		z = abs(z / c)/(dot(m, pi)) + (c / pi);
		
		color += exp(-cabs(z * pi / atan(c)) * pi);
		color -= exp(-3.974/cabs((zo / pi) / z - pi));
		
	}
	
	color /= 10.;
	
	return color;
}
float fractal2(vec2 z, vec2 c, float m, float color)
{		
	for ( int i = 0; i < N; i++ ){
		m = cabs(cdiv(z, c));
		
		vec2 zo = z;
		z = abs(z)/m + (c);
		
		color += exp(-cabs(z / atan(c)));
		color -= exp(-10.974/cabs((zo) / z));
		
	}
	
	color /= 10.;
	
	return color;
}
float fractal3(vec2 z, vec2 c, float m, float color)
{	
	for ( int i = 0; i < N; i++ ){
		m = cabs(z);
		
		vec2 zo = z;
		z = abs(z)/m + c;
		
		color += exp(-cabs(z));
		color += exp(-1./cabs(zo - z));
		
	}
	
	color /= 2.;
	
	return color;
}
void main( void ) {
	float pi2 = pi * 2.0;
	
	vec2 z = surfacePosition*60.21;
	vec2 c = vec2( -0.120, 0.060 );
	c += -1.0235 * vec2(wave((time * .021)/2.5), wave((time * .061)/1.42));
	
	float color = 0.50;			
	float m = 0.;
	
	color = max(fractal(z, c, m, color), fractal2(z, c, m, color));
	
	c = vec2( -0.120, 0.060 );
	c += -1.5 * vec2(wave((time * 111.01)/19.2347890), wave((time * 111111999797979911111111.2)/11197855645111.871923));//LOL
	color = fractal3(z, c, m, color);
	
	gl_FragColor = vec4(HSVtoRGB(
		wave(color + 27.12),
		wave(color * 19.1),
		wave(color * 15.23)
	), 1.0);
}