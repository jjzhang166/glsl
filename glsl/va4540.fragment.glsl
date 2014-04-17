#ifdef GL_ES
precision mediump float;
#endif

//it's fuckin beautiful *_*

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	
	gl_FragColor = vec4( 
				pow(
					mix(
						vec3(0.3, 0.25, 1.0),
						vec3(0.0, 0.75, 1.0),
						position.y
					),
					vec3(0.2)
				),
				1.0	
				
			);
}