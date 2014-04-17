/* Radial Gradient */
/* Series of scenes to improve my understanding */
/* Jnana Senapati */

// I wonder how long you can watch this until it becomes terribly glitchy - @dist

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 position = (gl_FragCoord.xy / resolution.xy);
	position.x -= 0.5;
	position.y -= 0.5;

	position.x /= resolution.y/resolution.x;
	
	float color = cos(time/length(position));

	gl_FragColor = vec4( vec3(-color, color, 0.0), 1.0 );
}