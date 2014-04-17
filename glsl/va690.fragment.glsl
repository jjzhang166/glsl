#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	gl_FragColor = gl_FragCoord.y > 100.0 ? vec4(1,1,1,1) : vec4(0,0,0,1);

}