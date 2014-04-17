/* Resolution */
/* Series of scenes to improve my understanding */
/* Jnana Senapati */

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	precision mediump float;

    	gl_FragColor.r = 1.0 - position.x;
	gl_FragColor.g = 1.0 - position.y / 0.9;
  	gl_FragColor.b = 1.0 - position.y * (.5 * position.x);
  	gl_FragColor.a = .0;

	
	// Calculates the position
	// Position is between 0 and 1
	// Lower left is 0.0 and 0.0

	//float red = 0.0;
	//float green = 0.0;
	//float blue = 0.0;
	
	//if(position.x<0.5) red=0.5;
	//if(position.y<0.5) blue=0.5;

//	gl_FragColor = vec4( vec3(red,green,blue),1.0 );
}