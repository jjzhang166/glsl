#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec4 hsv2rgba(vec3 hsv) {
	if (hsv.y == 0.) return vec4(hsv.z, hsv.z, hsv.z, 1.);
	vec3 rgb;
	hsv.x = mod((hsv.x + 36000.0), 360.0);
	int i = int(mod(hsv.x / 60., 6.));
	float f = (hsv.x / 60.) - float(i);
	float p = hsv.z * (1. - hsv.y);
	if (i == 0) return vec4(hsv.z, hsv.z * (1. - (1. - f) * hsv.y), p, 1.);
	else if (i == 1) return vec4(hsv.z * (1. - f * hsv.y), hsv.z, p, 1.);
	else if (i == 2) return vec4(p, hsv.z, hsv.z * (1. - (1. - f) * hsv.y), 1.);
	else if (i == 3) return vec4(p, hsv.z * (1. - f * hsv.y), hsv.z, 1.);
	else if (i == 4) return vec4(hsv.z * (1. - (1. - f) * hsv.y), p, hsv.z, 1.);
	else return vec4(hsv.z, p, hsv.z * (1. - f * hsv.y), 1.);
}
int julia (float x, float y, float cr, float ci) {
	float xx = x * x, yy = y * y;
	int n = 0;
	for (int i = 0; i < 360; i ++) {
		y = (x + x) * y + ci;
		x = xx - yy + cr;
		yy = y * y;
		xx = x * x;
		if (xx + yy > 10000.0 || i == 32) {
			n = i;
			break;
		}
	}
	return n;
}

void main( void ) {
	vec2 size = (gl_FragCoord.xy / resolution.xy) * 5.0;
	size -= 2.5;
	size.y += 0.4;
	int n = julia(size.x, size.y, 0.4, 0.4);
	if (n != 32) {
		float p = float(n) / 32.0;
		gl_FragColor = hsv2rgba(vec3(float(n + 400) * 0.1 + time * 200.0, 1.0, p));
	} else {
		gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
	}
}