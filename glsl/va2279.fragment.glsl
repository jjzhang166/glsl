#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	
	gl_FragColor = vec4(time / 10000.0, time, time, 1.0);
}