#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define RATE 10.0
void main( void ) {
	float val = floor(fract(time*RATE)+0.5);
	gl_FragColor = vec4(val, 1.-val, 1., 1.);
}