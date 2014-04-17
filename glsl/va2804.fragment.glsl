#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 mouse;

void main( void ) {
	gl_FragColor = vec4(mouse.x,mouse.y,0.3,1.0);
}