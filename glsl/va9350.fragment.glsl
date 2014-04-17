#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) ;
	
	vec3 couleur = vec3(04.0, 3.5, 3.0) / cos(position.x * 20.0) * tan(position.x * 40.0);
	
	vec3 couleur2 = vec3(12.0, 12.0, 12.0) * sin(position.y * 10.0) * cos(position.x * 10.0);
	
	vec3 couleur3 = vec3(1.4, 2.0, .0) * sin(position.y * 10.0) * cos(position.x * 15.0);
	
	gl_FragColor = vec4 (couleur + couleur3 + couleur2 * sin(time * 2.0), 1.0);

	
}