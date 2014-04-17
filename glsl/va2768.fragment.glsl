precision mediump float;

void main( void ) {

	float r = mod(gl_FragCoord.x / 20.0, 2.0) < 1.0 ? 0.0 : 1.0; 
	float g = mod(gl_FragCoord.y / 20.0, 2.0) < 1.0 ? 0.0 : 1.0; 
	gl_FragColor = vec4(r, g, 0, 1);

}