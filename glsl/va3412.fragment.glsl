#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	float scaline = abs(sin(gl_FragCoord.y/2.0))/10.0;

	
	gl_FragColor = vec4(scaline, scaline, scaline, 1.0);
}