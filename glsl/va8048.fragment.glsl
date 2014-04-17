#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	float color = 0.0;
	
	color += sin(position.x * 15.0 + cos(time * 0.25) * 10.0);
	color += cos(position.y * 10.0 + sin(time * 0.9) * 10.0);
	
	
	
	gl_FragColor = vec4(color, cos(color - time), sin(color + time), 1.0 );

}