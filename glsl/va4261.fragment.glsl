#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	

	if (gl_FragCoord.y > 256.0) gl_FragColor = vec4( 0.5,0.5,0.5,1.0 );

}