#ifdef GL_ES
precision mediump float;
#endif

// Best viewed in low quality

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rand(vec2 p) {
	return fract(sin(dot(p.xy,vec2(12.9898,78.233)))*43758.5453);
}

vec3 noise(vec2 f) {
	return vec3(rand(f-1.), rand(f), rand(f+1.));
}

void main( void ) {
	vec3 c = (1. - noise(gl_FragCoord.xy * .125 * vec2(mod(time, .1), mod(time+0.05, .1)))) * mod(gl_FragCoord.y, 2.);
	float g = (c.x+c.y+c.z)/3.;
	gl_FragColor = vec4( g*1.125 - c*0.125, 1.0);
}