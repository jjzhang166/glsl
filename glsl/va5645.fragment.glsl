#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	float h = -(mod(time/5.,2.) + 0.5);
	vec3 stuff = sin(PI*vec3(h, h + 0.33333, h + 0.66666));
	
	gl_FragColor = vec4(stuff*stuff, 1.0);

}