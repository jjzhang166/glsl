#ifdef GL_ES
precision mediump float;
#endif

uniform float time;

void main( void ) {

	bool b0 = sin(4.0*time) > 0.0;
	gl_FragColor = b0 ? vec4(1,0,0,1) : vec4(0,1,0,1);
}