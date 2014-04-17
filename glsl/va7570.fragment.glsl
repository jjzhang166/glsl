#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define N 3

void main (void){
	vec2 v = (gl_FragCoord.xy - resolution / 2.0) / min (resolution.y, resolution.x) * 20.0;
	float x = v.x;
	float y = v.y;
	
	float t = 0.4;
	float r;
	float factor = cos (.1);
	for (int i = 0; i < N; i ++){
		float d = 3.14159265 / float (12) * float (i) * 5.0 + mouse.y * 10. + time;
		r = length (vec2 (x, y)) + 0.01 + mouse.x * 5. + time * 2.;
		float xx = x;
		x = x + factor * (cos (y  + cos (r) + d) + cos (t));
		y = y - factor * (sin (xx + cos (r) + d) + sin (t));
	}

	float r0 = cos (r * 14.);
	float r1 = cos (r * 7.);
	float r2 = cos (r * 3.);
	gl_FragColor = 1. - vec4 (r2 - r0 * r1, r0, r1, 1.);
}