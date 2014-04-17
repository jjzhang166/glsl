#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	gl_FragColor = vec4( vec3(sin(time * 100.0)), 1.0);
}