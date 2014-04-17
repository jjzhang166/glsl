#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	float color = 0.0;
	color += sin(position.x * sin(time * 0.25) * 50.0);

	float col2 = 0.0;
	col2 += sin(position.y * cos(time * 0.25) * 50.0);
	
	gl_FragColor = vec4( 1.0, col2, color, 1.0 );

}