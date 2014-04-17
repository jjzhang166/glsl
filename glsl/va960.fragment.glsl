#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = gl_FragCoord.xy;

	float color = 0.9;
	if (mod(position.x, mouse.x * resolution.x) < 1.0 || mod(position.y, mouse.y * resolution.y) < 1.0) {
		color -= 0.1;
	}
	
	if (mod(position.x, mouse.x * 5.0 * resolution.x) < 1.0 || mod(position.y, mouse.y * 5.0 * resolution.y) < 1.0) {
		color -= 0.1;
	}
	

	gl_FragColor = vec4( vec3( color, color, color), 1.0 );

}