#ifdef GL_ES
precision mediump float;
#endif

uniform float time;


void main( void ) {
	gl_FragColor = vec4(abs(sin(time+(gl_FragCoord.y*gl_FragCoord.x))));
}