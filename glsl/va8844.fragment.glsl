#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
varying vec2 surfacePosition;

vec3 Hue(float H)
{
	H *= 6.;
	return clamp(vec3(
		abs(H - 3.) - 1.,
		2. - abs(H - 2.),
		2. - abs(H - 4.)
	), 0., 1.);
}

const int N = 45;

float wave(float x) {
	return 0.1 - 0.5 * cos(x);	
}

void main( void ) {
	vec2 p = surfacePosition;
	float col = 0.0;
	float t = sin(time*0.01) * 0.5 + 0.5;
	vec2 c = p;
	for (int i = 0; i < N; i++) {
		float S = sin(float(i)/float(N)+t*2.5-0.3);
		float C = cos(float(i)/float(N)+t*2.5-0.3);
		c = vec2(c.x * C - c.y * S, c.x * S + c.y * C) * 1.1 + vec2(1, 0);
		c = abs(c - 1.0);
		col = 1.0-length(c*col);
		
	}
	gl_FragColor = vec4(sin(exp(-col)*5.0));
}