#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	float color = 0.0;
	color += sin( position.x * cos( time / 30.0 ) * 80.0 ) + cos( position.y * cos( time / 30.0 ) * 80.0 );
	color += cos( position.x * cos( time / 30.0 ) * 60.0 ) + cos( position.y * sin( time / 30.0 ) * 60.0 );
		
	gl_FragColor = vec4(color * 0.0, color * 0.1, color * 0.5, 1.0);
}