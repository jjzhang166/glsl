/* Series of scenes to improve my understanding */
/* Jnana Senapati */

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	// Calculates the position
	// Maps position.x and y to a value between 0 and 1
	
	// Now need to use mouse and time

	float dots = 0.2;
	float yellow = 0.2;
	float blue = 0.2;
	
	if(position.x<0.5) dots=0.5;
	if(position.y<0.5) blue=0.5;

	gl_FragColor = vec4( vec3(dots,yellow,blue),1.0 );
}