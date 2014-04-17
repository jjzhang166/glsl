#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
varying vec2 surfacePosition;

void main() {
	vec2 p = surfacePosition;
	float d = 1.0;
	for (int i = 0; i < 20; i++) {
		float a = atan(p.y, p.x);
		float r = length(p);
		float s = dot(p, p);
		p = vec2(cos(a) - r, sin(a) - r);
		p = abs(p - r);
		d = min(d, r); // Try also: min(d, a);
	}
	gl_FragColor = vec4(sin(log(d*d)));
}