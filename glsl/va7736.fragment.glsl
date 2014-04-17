#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// B

#define PI 3.141592

float square(float x)
{
	return sin(x) > 0. ? 1. : -1.;
}

float sawtooth(float x)
{
	return -1. + mod(x / PI / 2., 2.);
}

void main( void ) {

	vec2 position = gl_FragCoord.xy / resolution.xy;

	float i = sin(time) * -100.;
	float r = sawtooth(length(position - .5) * i);
	float g = sin(length(position - .5) * i);
	float b = square(length(position - .5) * i);
	
	r *= 1. - sin(length(position - .5) * 2.);
	g *= 1. - sin(length(position - .5) * 2.);
	b *= 1. - sin(length(position - .5) * 2.);
	
	gl_FragColor = vec4( r * .2, g * .5, b, 1. );

}