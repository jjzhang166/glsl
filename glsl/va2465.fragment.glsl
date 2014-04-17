#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	float bla = gl_FragCoord.x/resolution.x; 
	float value = sin((bla-0.5)*100.0);
	gl_FragColor = vec4(value,value,value, 1.0 );

}