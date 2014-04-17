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
	if(length(p - vec2(-0.01562, 0.53646)) < min(t , 0.45313)) res = 0.;
	if(length(p - vec2(-0.01562, 0.53646)) < min(t - 0.45313, 0.43229)) res = 1.;
	if(length(p - vec2(-0.02604, 0.41667)) < min(t - 0.88542, 0.11458)) res = 0.;
	if(length(p - vec2(-0.02083, 0.375)) < min(t - 1., 0.13542)) res = 1.;
	if(length(p - vec2(-0.52604, 0.46875)) < min(t - 1.13542, 0.14063)) res = 0.;
	if(length(p - vec2(-0.50521, 0.46875)) < min(t - 1.27605, 0.11979)) res = 1.;
	if(length(p - vec2(0.51042, 0.48958)) < min(t - 1.39584, 0.14063)) res = 0.;
	//if(length(p - vec2(0.5, 0.48437)) < min(t - 1.53647, 0.11979)) res = 1.;
	if(length(p - vec2(-0.02083, 0.73437)) < min(t - 1.65626, 0.17188)) res = 0.;
	if(length(p - vec2(-0.02083, 0.77083)) < min(t - 1.82814, 0.19271)) res = 1.;
	if(length(p - vec2(0.49479, 0.48437)) < min(t - 2.02085, 0.09896)) res = 0.;
	if(length(p - vec2(0.47396, 0.46875)) < min(t - 2.11981, 0.08333)) res = 1.;
	if(length(p - vec2(0.44271, 0.46875)) < min(t - 2.20314, 0.05208)) res = 0.;
	if(length(p - vec2(-0.52604, 0.47396)) < min(t - 2.25522, 0.09375)) res = 0.;
	if(length(p - vec2(-0.50521, 0.44792)) < min(t - 2.34897, 0.08333)) res = 1.;
	if(length(p - vec2(-0.5, 0.45312)) < min(t - 2.4323, 0.0625)) res = 0.;
	if(length(p - vec2(-0.47396, 0.45312)) < min(t - 2.4948, 0.05208)) res = 1.;
	if(length(p - vec2(-0.02083, 0.78125)) < min(t - 2.54688, 0.13021)) res = 0.;
	if(length(p - vec2(-0.02083, 0.78125)) < min(t - 2.67709, 0.09375)) res = 1.;
	if(length(p - vec2(-0.02083, 0.78125)) < min(t - 2.77084, 0.05208)) res = 0.;
	if(length(p - vec2(-0.02083, 0.78125)) < min(t - 2.82292, 0.02604)) res = 1.;
	if(length(p - vec2(-0.02604, 0.22396)) < min(t - 2.84896, 0.21354)) res = 0.;
	if(length(p - vec2(-0.02604, 0.22396)) < min(t - 3.0625, 0.19792)) res = 1.;
	if(length(p - vec2(0.1875, 0.46875)) < min(t - 3.26042, 0.14063)) res = 0.;
	if(length(p - vec2(-0.23437, 0.45833)) < min(t - 3.40105, 0.13021)) res = 0.;
	if(length(p - vec2(-0.09375, 0.30729)) < min(t - 3.53126, 0.04167)) res = 0.;
	if(length(p - vec2(0.04688, 0.3125)) < min(t - 3.57293, 0.03646)) res = 0.;
	if(length(p - vec2(-0.10417, 0.28125)) < min(t - 3.60939, 0.04688)) res = 1.;
	if(length(p - vec2(0.05729, 0.29167)) < min(t - 3.65627, 0.04167)) res = 1.;
	if(length(p - vec2(-0.03125, 0.14062)) < min(t - 3.69794, 0.11979)) res = 0.;
	if(length(p - vec2(0.25, 0.54687)) < min(t - 3.81773, 0.02083)) res = 1.;
	if(length(p - vec2(-0.07812, 0.05208)) < min(t - 3.83856, 0.02083)) res = 1.;
	if(length(p - vec2(-0.23437, 0.45312)) < min(t - 3.85939, 0.10417)) res = 1.;
	if(length(p - vec2(-0.20833, 0.42708)) < min(t - 3.96356, 0.02083)) res = 0.;
	if(length(p - vec2(0.40625, 0.45312)) < min(t - 3.98439, 0.05208)) res = 1.;
	return res;
}

void main(void) {
	vec2 position = gl_FragCoord.xy / resolution.y;
	float clr = mod(length(position - vec2(.5 * resolution.x / resolution.y, .5)) - time / 4., .2) > .1 ? 0.3 : 0.2;
	float drw = drawing(position - vec2(.5 * resolution.x / resolution.y, 0), mod(time / 2., 5.));
	if(drw >= 0.) clr = drw;
	vec3 grd = mix(vec3(0.5922, 0.9373, 0.749), vec3(0.9373), position.y);
	gl_FragColor = vec4(vec3(1.) - grd * (1. - clr), 1.);
}