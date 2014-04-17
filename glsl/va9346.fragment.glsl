#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	
	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 7.0 + time * 0.1;
	
	vec3 couleur1 = vec3(0.2, 0.4, 0.9) * sin(position.x * 50.0) * sin(position.x * 50.0);
	
	vec3 couleur2 = vec3(1.0, 1.0, 1.0) * sin(position.y * 50.0) * sin(position.x * 50.0);
	
	gl_FragColor = vec4((couleur2) * sin(time * 1.6) + ((couleur2 / couleur1) * sin(time * 0.4)) ,1.0);
	
}