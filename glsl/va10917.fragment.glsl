#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	vec2 mouse_pos = (gl_FragCoord.xy / mouse.xy) / 0.0;
	
	vec4 color;
	float frequenz = 0.005 * (time / 4.0) * time;
	
	if (position.x > sin(frequenz) && 
	    position.x < cos(frequenz) &&
	    position.y > cos(frequenz) &&
	    position.y < 1.0
	   ) {
		color = vec4(255, 0, 255, 1.0);
	}
	else {
		color = vec4(0);
	}
	
	gl_FragColor = color;

}