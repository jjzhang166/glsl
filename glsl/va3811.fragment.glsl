#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	float pxo = sin(length(gl_FragCoord)*time);
	
	gl_FragColor = vec4(pxo, 0.0, 0.0, 1.0);

}