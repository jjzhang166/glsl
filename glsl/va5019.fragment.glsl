precision lowp float;

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform vec2 surfaceSize;
uniform vec3 color;

void main( void ) {
	
	float f3 = mouse.x;	// get the mouse's x position
	float f2 = mouse.y;	// get the mouse's y position
	
	vec4 color = vec4( .5, f2, f3, .1);	// put mouse position values in color values
	
	gl_FragColor = vec4( color );		// feed to fragcolor
}