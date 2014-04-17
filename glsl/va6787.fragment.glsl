#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;


void main( void ) {

	float color = 0.01;
	gl_FragColor = vec4( vec3( color, color * 0.5, sin( color + time / 3.0 ) * 0.75 ), 1.0 );

}