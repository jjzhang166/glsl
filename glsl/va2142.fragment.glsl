// The fire effect is coming...

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

#define MOUSE_SIZE 0.04
#define ASPECT_RATIO (resolution.y / resolution.x)
#define MOUSE_SQUARE 0
#define MOUSE_CIRCLE 1

#define FADE 0.98

vec3 hsv(float h,float s,float v) {
	return mix(vec3(1.),clamp((abs(fract(h+vec3(3.,2.,1.)/3.)*6.-3.)-1.),0.,1.),s)*v;
}

float rand(vec2 p) {
	return fract(sin(dot(p.xy,vec2(12.9898,78.233)))*43758.5453);
}

void main( void ) {

	vec2 p = gl_FragCoord.xy / resolution;

#if MOUSE_SQUARE
	if (abs(p.x - mouse.x) < MOUSE_SIZE * ASPECT_RATIO &&
	    abs(p.y - mouse.y) < MOUSE_SIZE) {
#endif
#if MOUSE_CIRCLE
	vec2 s = p.xy - mouse.xy;
	if (sqrt(s.x * s.x + pow(s.y * ASPECT_RATIO, 2.0)) < MOUSE_SIZE / 2.0 ) {
#endif
	    gl_FragColor = vec4(hsv(rand(vec2(time * p.x, time * p.y)) * 0.2 - 0.05, 1.0, 1.0), 1.0);
	    return;
	}
	
	gl_FragColor = texture2D(backbuffer, p) * FADE;
}