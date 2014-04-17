#ifdef GL_ES
precision mediump float;
#endif

void main( void ) {

	float color = 0.0;
	for(int t=0;t<2;t++) {
		color = 1.0;
	}
	

	gl_FragColor = vec4(color, 0, 0, 1.0 );

}