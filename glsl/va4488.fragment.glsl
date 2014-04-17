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
	if(length(p - vec2(-0.07292, 0.46354)) < min(t - 2.01564, 0.01042)) res = 0.;
	if(length(p - vec2(-0.00521, 0.45833)) < min(t - 2.02606, 0.02083)) res = 0.;
	if(length(p - vec2(-0.03646, 0.38542)) < min(t - 2.04689, 0.03646)) res = 0.;
	if(length(p - vec2(-0.04167, 0.36979)) < min(t - 2.08335, 0.03125)) res = 1.;
	if(length(p - vec2(0.13542, 0.80729)) < min(t - 2.1146, 0.03125)) res = 1.;
	if(length(p - vec2(-0.36458, 0.16667)) < min(t - 2.14585, 0.08333)) res = 0.;
	if(length(p - vec2(-0.34896, 0.18229)) < min(t - 2.22918, 0.06771)) res = 1.;
	if(length(p - vec2(0.34375, 0.17187)) < min(t - 2.29689, 0.15104)) res = 0.;
	if(length(p - vec2(0.30729, 0.20312)) < min(t - 2.44793, 0.125)) res = 1.;
	if(length(p - vec2(0.38542, 0.67187)) < min(t - 2.57293, 0.10417)) res = 0.;
	if(length(p - vec2(0.38542, 0.67708)) < min(t - 2.6771, 0.07813)) res = 1.;
	if(length(p - vec2(0.36979, 0.67708)) < min(t - 2.75523, 0.0625)) res = 1.;
	if(length(p - vec2(-0.51042, 0.52604)) < min(t - 2.81773, 0.09375)) res = 0.;
	if(length(p - vec2(-0.48437, 0.51562)) < min(t - 2.91148, 0.07813)) res = 1.;
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