#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	float color = 0.0;
	color += sin( position.x * cos( time / 10.0 ) * 100.0 ) + sin( position.y * cos( time / 23.0 ) * 80.0 );
	color += sin( position.x * cos( time / 2300.0 ) * 5.0 ) + cos( position.y * sin( time / 30.0 ) * 623.0 );
		
	gl_FragColor = vec4(color * 0.9, color * 0.23, color * 0.9, 1.0);
}