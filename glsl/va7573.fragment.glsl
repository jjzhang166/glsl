#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

/*
	First try at glsl
	I've got no idea what I am doing :p
	Ok I do, a little
*/

float PI = 3.141592;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	float x = cos(time) + sin(time / 20.) * 10. + 10.;
	float y = sin(time) + cos(time / 10.) * 10. + 10.;
	float r = pow(sin(time * 5. + position.x * x) / 5., position.y * 2.) * x;
	float g = pow(sin(time * 5. + position.y * y) / 5., position.x * 2.) * y;
	float b = (r + g) / 2.;
	gl_FragColor = vec4( r, g, b, 1.0 );

}