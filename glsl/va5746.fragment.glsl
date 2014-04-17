#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) 
{
	//gl_FragCoord treats the origin as the bottom left of the window
	
	// Normalize the FragCoord
	vec2 position = vec2(gl_FragCoord.x/resolution.x, gl_FragCoord.y/resolution.y);
	
	gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0 );
	
	// top left red
	// bottom left blue
	// top right green
	// bottom right yellow
	
	// breaking down what I wanted out of each color component helped
	
	gl_FragColor.r = abs((position.x) - (position.y));
	gl_FragColor.g = (position.x);
	gl_FragColor.b = (1.0 - position.x)*(1.0 - position.y);
	
}