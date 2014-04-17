#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float noise(vec2 p) {
	p=(p);
	return fract(sin(p.x*45.11+p.y*97.23)*878.73+733.17);
}

vec3 grid(float r, float d, vec2 p, float w, vec2 c, vec3 o) {
	vec2 q = c - p;
	float a = atan(q.y, q.x);
	float ds = length(q);
	return (mod((a + r) * 3.141 + ds * w, 1.0) > 0.5 != mod(ds, d) > d * 0.5) ? o : vec3(0.0);
}

#define N(t, x, l, h) ((noise(vec2(t, x)) - l) * (h - l))

void main( void ) {
	vec3 col = vec3(0.0);
	vec2 p = gl_FragCoord.xy / resolution.xy * 2.0 - vec2(0.5);
	float tt = floor(time);
	if (p.x >= 0.0 && p.y >= 0.0 && p.x <= 1.0 && p.y <= 1.0) {
		col += grid(time * N(tt, 0.0, -0.5, 0.5), N(tt, 1.0, 0.4, 2.0), vec2(N(tt, 2.0, 0.0, 1.0), N(tt, 3.0, 0.0, 1.0)), floor(N(tt, 4.0, 0.0, 5.0)), p, vec3(1.0, 0.0, 0.0));
		tt = floor(time) + 0.2432;
		col += grid(time * N(tt, 0.0, -0.5, 0.5), N(tt, 1.0, 0.4, 2.0), vec2(N(tt, 2.0, 0.0, 1.0), N(tt, 3.0, 0.0, 1.0)), floor(N(tt, 4.0, 0.0, 5.0)), p, vec3(0.0, 1.0, 1.0));
		}
	gl_FragColor = vec4(col, 1.0);
}