#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	float r = sin(10.0 * gl_FragCoord.x * gl_FragCoord.y + 2.0*time);;
	float g = cos(0.01 * gl_FragCoord.x * gl_FragCoord.y + 4.0*time);
	float b = sin(1.0 *  gl_FragCoord.x * gl_FragCoord.y + 8.0*time);
	
	gl_FragColor = 1.0 * vec4(r, g, b, 1.0);
}