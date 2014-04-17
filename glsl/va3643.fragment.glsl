precision mediump float;
uniform vec2 resolution;
uniform float time;

void main( void ) {

	float a = cos(time)*gl_FragCoord.y+((gl_FragCoord.x/0.1)*cos(time*gl_FragCoord.x*gl_FragCoord.y)) < 10.0 ? 0.0 : 1.0; 
	float g = mod(gl_FragCoord.y / 20.0, 2.0) < 1.0 ? 0.0 : 1.0; 
	gl_FragColor = vec4(0, a, 0, 1);

}