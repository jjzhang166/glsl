/* Radial Gradient */
/* Series of scenes to improve my understanding */
/* Jnana Senapati */


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

	float color = 1.0 - length(position);

	gl_FragColor = vec4( vec3(0.0, color, 0.0), 1.0 );
}