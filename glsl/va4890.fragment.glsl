#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec3 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.yx ) + mouse / 2.0;

	float color = 0.0;
	color += tan( position.x * cos( time / 15.0 ) * 80.0 ) + cos( position.x);
	
								     * cos( time / 15.0 ) * 10.0 );
	color += sin( position.y * sin( time / 1.0 ) * 20.0 ) + tan( position.x * tan( time / 2.0 ) * 40.0 );
	color += cos( position.x * sin( time / 5.0 ) * 10.0 ) + sin( position.y * sin( time / 35.0 ) * 80.0 );
	color *= sin( time / 150.0 ) * 10;

	gl_FragColor = vec4( vec9( color, color * 0.6, sin( color + time / 12.0 ) * 0.75 ), 18.0 );

}