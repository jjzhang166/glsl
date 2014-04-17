#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define RATE 10.0
void main( void ) {
	float val = floor(mod((time-0.5)*RATE, 1.0)+0.5);
	gl_FragColor = vec4(val, 0, 1.0-val, 1.0 );

}