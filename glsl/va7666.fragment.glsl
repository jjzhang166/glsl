#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 mouse;
	
	
void main(void) {

	gl_FragColor = vec4(mouse.x, mouse.y, sin(mouse.x)*cos(mouse.y), 1.0);

}