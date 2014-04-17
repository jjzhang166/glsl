precision mediump float;
uniform vec2 resolution;
uniform float time;
void main( ) {
	float f = sin(time*30.0);
	f = abs(f);
	gl_FragColor = vec4(pow(f, 5.0));

}