#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	gl_FragColor = vec4(step(gl_FragCoord.x, 500.0), step(gl_FragCoord.y, 300.0), 1.0, 1.0 );
}