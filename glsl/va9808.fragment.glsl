#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
varying vec2 surfacePosition;

void main() {
	vec2 p = surfacePosition;
	float d = 1.0;
	for (int i = 0; i < 40; i++) {
		float a = atan(p.y, p.x);
		float r = length(p);
		p = vec2(cos(a) - r, sin(a) - r);
		p = abs(p - r);
		d = min(d, r);
		p = asin(sin(p/r + (mouse*4.0 - 2.0))); // Try acos too
	}
	gl_FragColor = vec4(sin(log(pow(16.0, pow(1.0-d, 1.0/p.x)))),
			    sin(log(pow(32.0, pow(1.0-d, 1.0/p.y)))),
			    sin(log(pow(64.0, pow(1.0-d, 1.0/length(p))))),
			    1.0);
}