#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	float r = abs(sin(time));
	float g = mouse.x;
	float b = abs(sin(time));
	gl_FragColor = vec4(r, g, b, 1.0);
}