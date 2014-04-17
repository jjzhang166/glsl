#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	float color = mouse.x * mouse.y;
	gl_FragColor = vec4(color, color, 1.0, 1.0);
}