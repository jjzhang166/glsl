#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse /4.0;

	float intensity = tan(sin(time*9.0 + position.x));
	
	vec3 color = intensity * vec3(1.0, 0.5, 0.8);
	
	float intensity2 = cos(position.y * 23.5);
	vec3 color2 = intensity2 * vec3(0.0, 0.9, 0.3);

	
	gl_FragColor = vec4(color+color2, 1.0 );

}