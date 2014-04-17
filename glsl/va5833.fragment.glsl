#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = gl_FragCoord.xy;
	float a = mod(position.x * position.y, time) / 100.0;
		

	gl_FragColor = vec4( vec3( a, a, a), 1.0 );
}