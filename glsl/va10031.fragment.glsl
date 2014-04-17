#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse;
	float color = 0.0;
	
	color = sin(position.x * 20.0) * sin(position.y * 10.0) * cos(time * 0.4) ;
	
	//gl_FragColor = vec4( vec3(-sin(color) * 0.5, color * color, sin(color)), 1.0 );
	gl_FragColor = vec4( 1.0, 1.0, 0.0, 0.1 );

}