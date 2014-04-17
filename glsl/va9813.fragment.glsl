// T-circle

// 0.5, hide code, and zoom in

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
varying vec2 surfacePosition;

float square( vec2 p, float b )
{
	vec2 d = abs(p) - b;
	return min(max(d.x, d.y), 0.0) + length(max(d, 0.0));
}

float circle(vec2 p, float b)
{
	return length(p) - b;
}

void main( void ) {

	vec2 p = surfacePosition + 1.0;
	float c = 1.0;
	float s = 1.0;
	for (int i = 0; i < 15; i++) {
		p = abs(p - s);
		s *= 0.5;
		c = min(c, circle(p, s));
	}

	gl_FragColor = vec4(1.0 - step(c, 0.0) - c);
}