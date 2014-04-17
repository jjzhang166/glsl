#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	gl_FragColor = vec4(fract(abs(sin(time*15.+ resolution.x*100.))),fract(abs(sin(time*3. + 0.3))),fract(abs(sin(time*10.))),1.0);
}