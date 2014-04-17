#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;
	
	vec3 couleur = vec3(0.0, 1.5, 0.0) * sin(position.x * 10.0) * cos(position.y * 30.0);
	
	vec3 couleur2 = vec3(1.0, 1.0, 1.0) * sin(position.y * 10.0) * cos(position.x * 10.0);
	
	
	gl_FragColor = vec4 (couleur + couleur2 * sin(time * 6.0), 1.0);

	
}