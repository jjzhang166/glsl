#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	
	vec4 color = vec4(0.0, 0.0, 0.0, 0.0);
	
//	if (distance(gl_FragCoord.xy - mouse.xy) < 2.0)
	{
		color = vec4(0.0, 0.0, 0.0, 0.0);
	}
	    
	gl_FragColor = color;
}