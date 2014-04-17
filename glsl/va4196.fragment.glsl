#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	
	float x = gl_FragCoord.x - (mod(time, 20.) * 100.);
	
	gl_FragColor = (mod(x, 20.) < 10.)
		? vec4(1., 0., 0., 1.0)
		: vec4(0.1, 0.8, 0.9, 1.0);
}