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

vec3 noise(vec2 p) {
	return vec3(rand(p-1.), rand(p), rand(p+1.)) * 1. / mod(p.x, .2) * (1. - mod(p.y, .5));
}

void main( void ) {
	vec3 c = noise(gl_FragCoord.xy * time);
	gl_FragColor = vec4(c, 1.0);
}