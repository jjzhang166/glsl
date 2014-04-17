#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define N 4
#define OFF .02
#define FREQ 12.
#define THICKNESS 20.

float wave(vec2 p, vec2 f)
{
	p += f;
	float a = sin(p.x * FREQ * sin(time / 10000.));
	float o = sin(.5 * (time + p.x)) * .125;
	o *= sin(p.x * p.y * .02) * sin(time * 5.);
	float t = 1. - pow(abs(p.y - .5 - o - a * .2), 1.2) * THICKNESS;
	return t < 0. ? 0. : t;
}

void main( void ) {

	vec2 p = ( gl_FragCoord.xy / resolution.xy );

	float color = 0.;
	for(int i = 0; i < N; i++)
	{
		color += wave(vec2(p.x + time / 4., p.y), vec2(float(i) * OFF, 0.));
	}
	float r = color > 1. ? fract(color) : 0.;
	color = color > 1. ? 1. - fract(color) : color;
	
	gl_FragColor = vec4( r, color, color, 1. );

}