// @void256
// fuck yeah! "art is resistance" shader ;-P
//
// http://en.wikipedia.org/wiki/Characters_and_organizations_in_the_Year_Zero_alternate_reality_game#Art_is_Resistance

#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265359

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float pulse(float a, float b, float x) {
	return step(a, x) - step(b, x);
}

float block(vec2 pos, float width, float height, float xoff, float yoff) {
	return
		pulse(xoff, xoff + width, pos.x) *
		pulse(yoff, yoff + height, pos.y);
}

vec4 star(vec4 c) {
	float rmin = 0.031;
	float rmax = 0.09;
	float sctr = 0.15;
	float tctr = 0.52;
	float starangle = 2.*PI/5.;

	vec3 p0 = rmax*vec3(cos(0.), sin(0.), 0.);
	vec3 p1 = rmin*vec3(cos(starangle/2.), sin(starangle/2.), 0.);
	vec3 d0 = p1 - p0;
	vec2 ss = (gl_FragCoord.xy / resolution) - vec2(sctr, tctr);
	float angle = atan(ss.x, ss.y);
	float r = sqrt(ss.x*ss.x + ss.y*ss.y);
	float a = mod(angle, starangle) / starangle;
	if (a >= 0.5) {
		a = 1. - a;
	}
	vec3 d1 = r*vec3(cos(a), sin(a), 0) - p0;
	float i = step(0., cross(d0, d1).z);
	return mix(c, vec4(0.0, 0.0, 0.0, 1.0), i);
}

void main( void ) {
	vec3 fg = vec3(0.6, 0.0, 0.0);
	vec2 pos = gl_FragCoord.xy / resolution.xy;
	vec3 c1 =
		fg * block(pos, 0.55, 0.25, 0.425, 0.685) +
		fg * block(pos, 0.65, 0.25, 0.325, 0.405) +
		fg * block(pos, 0.95, 0.25, 0.025, 0.125) +
		fg * block(pos, 0.28, 0.53, 0.025, 0.405) +
		fg * block(pos, 0.10, 0.25, 0.305, 0.685);
	gl_FragColor = star(vec4(c1, 1.0));
}
