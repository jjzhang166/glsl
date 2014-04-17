/*
 * kaliset (http://www.fractalforums.com/new-theories-and-research/very-simple-formula-for-fractal-patterns/)
 * by Piers Haken.
 * 
 */

#ifdef GL_ES
precision highp float;
#endif

varying vec2 surfacePosition;

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
//uniform float time;

const int max_iteration = 35;
//const float bailout = 1000000.;

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


float saw (const float v)
{
	return sin(6.2*v) * 1.5 - 0.5;
	return abs(fract(v)-.5) * 2.5 - .5;
	return log(abs(1.-2.*fract(v+.5)) * 3.0);
}


vec3 Hue(float H)
{
	H *= 9.;
	return clamp(vec3(
		abs(H - 1.) - 1.,
		2. - abs(H - 3.),
		2. - abs(H - 5.)
	), 0., 1.);
}

vec3 HSVtoRGB(float h, float s, float v)
{
    return ((Hue(h) - 1.) * s + 1.) * v;
}

float wave(float t) { t /= 2.; t += 14.; return .5 - .5 * cos (sqrt(abs(t*sin(t*.2)))); }

void main( void )
{
	//vec2 c = (mouse-1.) * 2.;
	//vec2 c = (.1-mouse) * 2.5;
	vec2 c = vec2(0.,0.);
	
	c += -1.5 * vec2(wave(time/19.2347890), wave(time/23.871923));
	
	vec2 z = sqrt(abs(surfacePosition));
	
	float color = 0.;
	float m = 0.;
	for (int i = 0; i < max_iteration; ++i)
	{
		m = cabs(z);
		//if (m > bailout)
		//	break;
		
		vec2 zold = z;
		z = abs(z)/m + c;
		
		color += exp(-cabs(z));
		color += exp(-1./cabs(zold - z));
	}
	
	color /= 25.;

	gl_FragColor = vec4(HSVtoRGB(
		wave(color + time / 10.),
		wave(color * 3.7891),
		wave(color * 13.3234)
	), 1.0);
	
}