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
	if(length(p - vec2(0.02083, 0.50521)) < min(t, 0.47917)) res = 0.;
	if(length(p - vec2(0.02083, 0.42708)) < min(t - 0.47917, 0.39063)) res = 1.;
	if(length(p - vec2(-0.08333, 0.79687)) < min(t - 0.8698, 0.11979)) res = 0.;
	if(length(p - vec2(0.16667, 0.6875)) < min(t - 0.98959, 0.18229)) res = 0.;
	if(length(p - vec2(0.08854, 0.57812)) < min(t - 1.17188, 0.13542)) res = 1.;
	if(length(p - vec2(-0.23958, 0.61979)) < min(t - 1.3073, 0.10938)) res = 0.;
	if(length(p - vec2(-0.21875, 0.56771)) < min(t - 1.41668, 0.09896)) res = 1.;
	if(length(p - vec2(-0.29687, 0.67187)) < min(t - 1.51564, 0.07292)) res = 1.;
	if(length(p - vec2(-0.25, 0.76562)) < min(t - 1.58856, 0.08854)) res = 0.;
	if(length(p - vec2(-0.01042, 0.19792)) < min(t - 1.6771, 0.10938)) res = 0.;
	if(length(p - vec2(-0.38542, 0.47917)) < min(t - 1.78648, 0.0625)) res = 1.;
	if(length(p - vec2(0.42708, 0.50521)) < min(t - 1.84898, 0.0625)) res = 1.;
	if(length(p - vec2(0.04167, 0.15625)) < min(t - 1.91148, 0.01563)) res = 1.;
	if(length(p - vec2(-0.01042, 0.3125)) < min(t - 1.92711, 0.04167)) res = 1.;
	if(length(p - vec2(-0.375, 0.88021)) < min(t - 1.96878, 0.11458)) res = 0.;
	if(length(p - vec2(0.41146, 0.875)) < min(t - 2.08336, 0.10417)) res = 0.;
	if(length(p - vec2(0.14063, 0.25)) < min(t - 2.18753, 0.01563)) res = 0.;
	if(length(p - vec2(0.00521, 0.47917)) < min(t - 2.20316, 0.16667)) res = 0.;
	if(length(p - vec2(0, 0.48437)) < min(t - 2.36983, 0.15104)) res = 1.;
	if(length(p - vec2(0.00521, 0.47917)) < min(t - 2.52087, 0.05729)) res = 0.;
	return res;
}

void main(void) {
	vec2 position = gl_FragCoord.xy / resolution.y;
	float clr = mod(length(position - vec2(.5 * resolution.x / resolution.y, .5)) - time / 4., .2) > .1 ? 0.3 : 0.2;
	float drw = drawing(position - vec2(.5 * resolution.x / resolution.y, 0), mod(time / 2., 3.5));
	if(drw >= 0.) clr = drw;
	vec3 grd = mix(vec3(0.5922, 0.9373, 0.749), vec3(0.9373), position.y);
	gl_FragColor = vec4(vec3(1.) - grd * (1. - clr), 1.);
}