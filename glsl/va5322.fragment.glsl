#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) -0.02;
	
	vec4 color = vec4(0.0);

	float dist = distance(mouse, position) * 88.0;
	
	color += vec4(sin(dist - cos(time) * 15.));
	color *= vec4(0.0, 1.0 * cos(sin(dist * time)), pow(1.0 - cos(sin(dist * time)),0.2), 1.0);
	
	gl_FragColor = color;
}