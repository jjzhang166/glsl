#ifdef GL_ES
precision mediump float;
#endif

#define FG (vec3(0.8))
#define BG (vec3(0.7))
#define RING (vec3(1.0))
#define PI (3.14159265)
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 p2 = gl_FragCoord.xy - resolution.xy * 0.5;
	p2 /= 8.;
	p2 *= pow(1.04, p2.y+68.);
	p2.y *= 1.5;
	p2 /= 2.;
	float angle = atan(p2.y, p2.x) + time;
	vec3 fg, bg;
	if (mod(time, 2.0) < 1.0) {
		fg = FG; bg = BG;
	} else {
		fg = BG; bg = FG;
	}
	vec3 col = bg;
	if (mod(angle / (2.0 * PI) * 3.0, 1.0) < 0.5)
		col = fg;
	float fd = min(resolution.x, resolution.y) * 0.2;
	float t = 0.5 + 0.5 * ((sqrt(1.0 - pow(cos(3.0*angle), 2.0))));
	float w = length(p2) + t * 0.18 * fd;
	if (w < fd * 0.9 * (0.8 + 0.1 * abs(sin(time * 4.0)) + sin(time) * 0.2)) {
		col = vec3(0.0);
	} else if (w < fd * (0.8 + 0.1 * abs(sin(time * 8.0)) + sin(time) * 0.2)) {
		col = RING;
	}
	col *= vec3(0.8) + vec3(cos(time * 0.5), cos(time * 0.7), cos(time * 0.3)) * 0.2;
	gl_FragColor = vec4(col, 1.0);
}