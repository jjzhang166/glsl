#ifdef GL_ES
precision mediump float;
#endif

varying vec2 surfacePosition;

void main( void ) {


	float color = 0.0;

	gl_FragColor= vec4( vec3( color, color * 0.5, sin( color / 3.0 ) * 0.75 ), 1.0 );

}