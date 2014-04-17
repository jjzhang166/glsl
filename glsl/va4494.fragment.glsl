// Psylteflesk HD, sorta
// by gngbng

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

float drawing(vec2 p, float t) {
	float res = -1.;
	// what a disaster
	if(length(p - vec2(-0.03125, 0.46354)) < min(t, 0.45833)) res = 0.;
	if(length(p - vec2(-0.27604, 0.81771)) < min(t - 0.45833, 0.13021)) res = 0.;
	if(length(p - vec2(-0.02604, 0.46875)) < min(t - 0.58854, 0.42188)) res = 1.;
	if(length(p - vec2(-0.26562, 0.80208)) < min(t - 1.01042, 0.10938)) res = 1.;
	if(length(p - vec2(0.17188, 0.84896)) < min(t - 1.1198, 0.14583)) res = 0.;
	if(length(p - vec2(0.17708, 0.85417)) < min(t - 1.26563, 0.125)) res = 1.;
	if(length(p - vec2(0.15625, 0.81771)) < min(t - 1.39063, 0.0625)) res = 0.;
	if(length(p - vec2(-0.27083, 0.81771)) < min(t - 1.45313, 0.01563)) res = 0.;
	if(length(p - vec2(-0.03125, 0.44792)) < min(t - 1.46876, 0.26563)) res = 0.;
	if(length(p - vec2(-0.16146, 0.60937)) < min(t - 1.73439, 0.0625)) res = 1.;
	if(length(p - vec2(0.05729, 0.63542)) < min(t - 1.79689, 0.05729)) res = 1.;
	if(length(p - vec2(-0.05729, 0.65104)) < min(t - 1.85418, 0.05729)) res = 1.;
	if(length(p - vec2(-0.04167, 0.42187)) < min(t - 1.91147, 0.10417)) res = 1.;

	return res;
}

void main(void) {
	vec2 position = gl_FragCoord.xy / resolution.y;
	float clr = mod(length(position - vec2(.5 * resolution.x / resolution.y, .5)) - time / 4., .2) > .1 ? 0.3 : 0.2;
	float drw = drawing(position - vec2(.5 * resolution.x / resolution.y, 0), mod(time / 2., 4.));
	if(drw >= 0.) clr = drw;
	vec3 grd = mix(vec3(0.5922, 0.9373, 0.749), vec3(0.9373), position.y);
	gl_FragColor = vec4(vec3(1.) - grd * (1. - clr), 1.);
}