#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = gl_FragCoord.xy;
	float a = mod(position.x * position.y, time) / 100.0;
	float b = mod(position.x * position.y, time) / 50.0;
	float c = mod(position.x * position.y, time) / 20.0;
		

	gl_FragColor = vec4( vec3( a, b, c), 1.0 );
}