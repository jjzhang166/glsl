#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	float r = 1.0;
	float g = 0.5;
	float b = 0.5;
	
	float power_level = 1.0;
	r = mod(power_level*time,1.0);
	
	gl_FragColor = vec4( r, g, b, 1.0 );

}