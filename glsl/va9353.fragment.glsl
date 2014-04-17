#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse; 
	
	float intensity = sin(time * 3.0 + position.y * 30.0);
	vec3 color = intensity * vec3(0.0, 0.5, 9.8);
	
	float intensity2 = cos(position.y * 23.5);
	vec3 color2 = intensity2 * vec3(0.0, 10.9, 9.3);

	gl_FragColor =  vec4 (color+color2, 40.0);

}