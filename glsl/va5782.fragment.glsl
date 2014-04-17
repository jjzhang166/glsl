#ifdef GL_ES
precision mediump float;
#endif

//Amiga Copper rulez forever!

uniform vec2 mouse;
uniform float random;

void main( void ) {
	
	// Get a value between -1.0 and 1.0 based on y coord 
	// Basically making bands
	float blue_val = cos(gl_FragCoord.y *mouse.x/ 50.0);
	float red_val = sin(gl_FragCoord.x *mouse.y/ 100.0);
	
	gl_FragColor = vec4(red_val,0,blue_val,1.0);
	
}