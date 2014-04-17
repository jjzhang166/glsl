#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	
	
	
	
	

	// MADE BY CHAERIS!
	
	
	
	
	
	
	vec2 position = ( gl_FragCoord.xy - resolution.xy ) / length(resolution.xy) * 400.0;
	position.y += sin(position.x * 0.1 - time) * 2.0;
	position.x += sin(position.y * -0.03 - time) * 2.0;
	vec3 color;
	float pos = position.y * (83.0/53.0);
	if(abs(position.x) < 358./3.) {
		color = vec3(1.0, 0.0, 0.0);
	}
	else if(abs(position.x) < 352./3.*2.) color = vec3(1.0, 1.0, 1.0);
	else if(abs(position.x) < 358./3.*3.) color = vec3(0.0, 0.0, 1.0);
		
	gl_FragColor = vec4(color * (-cos(position.x * 0.1 - time) * 0.3 + 0.7), 1.);
}