/*
 * mandelbox julias
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

const int max_iteration = 6;
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

vec2 circle (float a) { return vec2 (cos(a), sin(a)); }

mat2 rotate(float a)
{
	return mat2(cos(a), -sin(a), sin(a), cos(a));
}

float ballFold(float m)
{
	  if (m < .5)
		  return m/(.5*.5);
	  else if (m < 1.)
		  return 1./(m*m);
	  return m;
}
void main( void )
{
	#if 0
	vec2 c = (mouse * 2. - 1.) * 2.;
	#else
	vec2 c = 3. * vec2(wave(time/3.2347890), wave(time/3.871923));
	//c = circle(time / PI) * .8 + circle(time) * .2;
	#endif

	//vec2 z = (surfacePosition * c + 1.)/c;
	vec2 z = surfacePosition*5. - 1.;

	//z = vec2(0.,0.);
	//c = surfacePosition * 4.;

	float scale = -1.77;
	scale = (mouse.x * 2. -1.) * 3.;
	//scale = mouse.x * 3.;
	
	float R = mouse.y * 2. + 1.25;

	float color = 0.;
	float m = 0.;
	vec2 zold;
	for (int i = 0; i < max_iteration; ++i)
	{
		zold = z;
		
		z = clamp(z, -1., 1.) * R - z;
		z = z * clamp(1./dot(z,z), 1., R*R) * scale + c;

		color += exp(-cabs(z));
		//color += exp(-1./cabs(zold - z));
	}
	
	//color = exp(-cabs(z)) * 100.;
	//color = exp(-1./cabs(zold - z)) * 3.;
	
	color /= 5.;
	color /= sqrt(scale);

	gl_FragColor = vec4(HSVtoRGB(
		wave(color + time / 10.),
		wave(color * 3.7891),
		wave(color * 13.3234)
	), 1.0);
}