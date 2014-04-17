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

float cabs (const vec4 c) { return dot(c,c); }

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

float wave(float t) { return (.5 - .5 * cos (t)); }

void main( void )
{
	//vec2 c = (mouse-1.) * 2.;
	//vec4 c = vec4((.1-mouse) * 2.5,sin(time),cos(time));
	vec4 c = vec4(0.);
	
	c += -1.5 * vec4(wave(time/10.2347890), wave(time/30.871923), wave(time/20.5649035643), wave(time/20.948276124));
	
	vec4 z = vec4(surfacePosition,surfacePosition.x*wave(time/35.345894) + surfacePosition.y*wave(time/12.75676547654), surfacePosition.x*wave(time/15.23432) + surfacePosition.y*wave(time/40.));
	
	if (gl_FragCoord.x < 100.) {
		gl_FragColor = fract(vec4(distance(z.xyxy, c),distance(z.xyyy, c),distance(z.yyxy, c),distance(z.xxxy, c)));
		return;
	}
	
	float color = 0.;
	float m = 0.;
	for (int i = 0; i < max_iteration; ++i)
	{
		m = cabs(z);
		//if (m > bailout)
		//	break;
		
		vec4 zold = z;
		z = abs(z)/m + c;
		//z = abs(z-.001)/m +c;
		
		
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