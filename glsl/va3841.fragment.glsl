#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	float scaline = abs(sin(10.0 * mouse.y + gl_FragCoord.y/30.0))/1.0;

	
	gl_FragColor = vec4(scaline, scaline, scaline, 0.0);
}