//achtergrond blauw overgang


#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


	void main( void ) {
	
	vec2 position = (gl_FragCoord.y / resolution.xy);
	
	position.x -= .5;
	
	
	float color = 1.2 - length(position);

	gl_FragColor = vec4( vec3(.0, color, 5.0), 7.0 );
	

	
	
}