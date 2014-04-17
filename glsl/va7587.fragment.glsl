#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec3 pink = vec3(224,77,251);
	vec3 blue = vec3(111,216,235);
	vec3 green = vec3(122,214,61);
	
	
	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;


	gl_FragColor = vec4( blue, 1.0 );

}