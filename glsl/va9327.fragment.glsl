#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 7.0;
	
	vec3 couleur = vec3(02.0, 1.5, 0.0) * tan(position.x * 15.0) * cos(position.y * 15.0);
	
	vec3 couleur2 = vec3(12.0, 12.0, 12.0) / tan(position.y * 10.0) / cos(position.x * 10.0);
	
	vec3 couleur3 = vec3(1., 1.0, 1.) * abs(tan(position.y * 10.0)) * abs(tan(position.x * 20.0));
	
	gl_FragColor = vec4 (couleur3 * abs(tan(time * 1.0)), 6.0);

	
}