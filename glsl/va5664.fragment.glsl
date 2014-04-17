/*
 * kaliset (http://www.fractalforums.com/new-theories-and-research/very-simple-formula-for-fractal-patterns/)
 * by Piers Haken.
 * 
 */

#ifdef GL_ES
precision highp float;
#endif

const float PI = 3.1415926535897932384626433832795;

varying vec2 surfacePosition;

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const int max_iteration = 35;
//const float bailout = 1000000.;

vec2 circle (float a) { return vec2 (cos(a), sin(a)); }

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

vec2 clog (const vec2 z)
{
	return vec2 (log(length(z)), atan(z.y, z.x));
}

vec2 cexp (const vec2 z)
{
	return circle(z.y) * exp(z.x);
}

vec2 cpow (const vec2 base, const vec2 ex)
{
	return cexp (cmul (clog (base), ex));
}

vec2 cpow (const vec2 base, const float ex)
{
	return circle(atan(base.y, base.x) * ex) * exp(log(length(base)) * ex);
}


float saw (const float v)
{
	return sin(6.2*v) * 1.5 - 0.5;
	return abs(fract(v)-.5) * 2.5 - .5;
	return log(abs(1.-2.*fract(v+.5)) * 3.0);
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

float wave(float t) { return .5 - .5 * cos (t); }

vec2 one2 = vec2(1.,0.);


mat2 rotate(float a)
{
	return mat2(cos(a), -sin(a), sin(a), cos(a));
}

void main( void )
{
	#if 0
	vec2 c = (mouse * 2. - 1.) * 1.5;
	#else
	vec2 c = -1.8 * vec2(wave(time/13.2347890), wave(time/15.871923));
	//c = circle(time / PI) * .8 + circle(time) * .2;
	#endif
	
	vec2 z = surfacePosition*3.;
	
	float color = 0.;
	float m = 0.;
	float mp = 0.;
	for (int i = 0; i < max_iteration; ++i)
	{
		mp = m;
		m = sqrt (cabs(z));
		//if (m > bailout)
		//	break;
		
		vec2 zold = z;
		vec2 az = abs(z);
		//z = cmul (abs(z), abs(z)) + c;
		//z = abs (cmul (z, z)) + c;
		//z = abs (cmul (z, z) - c) + c;
		//z = abs(cdiv(one2, z) + c);
		//z = abs(cpow(z, -5.) + c);	// integral real power
		//z = abs(cpow(z, -13./8.) + c);	// fractional real power
		z = abs(cpow(z, 5. * (mouse * 2. - 1.))) + c;	// mouse-driven complex power
		
		#if 0
		color += exp(-1./abs(mp-m));
		#else
		color += exp(-cabs(z));
		color += exp(-1./cabs(zold - z));
		#endif
	}
	
	color /= 25.;

	gl_FragColor = vec4(HSVtoRGB(
		wave(color + time / 10.),
		wave(color * 3.7891),
		wave(color * 13.3234)
	), 1.0);
	
}