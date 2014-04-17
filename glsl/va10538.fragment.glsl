#ifdef GL_ES
precision mediump float;
#endif

uniform float time; 		
uniform vec2 mouse; 		
uniform vec2 resolution; 	
				

vec4 do_mouse(vec2 mpos, float modifier) {
	return vec4((gl_FragCoord.x* 0.003) ,(gl_FragCoord.y * 0.002),cos(((gl_FragCoord.y/4.0) * gl_FragCoord.x * time) / 3.14),1.0);
}


void main( void ) {
	
	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;
	


	gl_FragColor = do_mouse(mouse, 0.4);
}