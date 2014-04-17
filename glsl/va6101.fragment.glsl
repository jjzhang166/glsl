#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 40.0 * mouse;

	float color = 0.0;
	color += cos( position.x * cos( time / 15.0 ) * 80.0 ) + cos( position.y * cos( time / 15.0 ) * 10.0 );
	color += cos( position.y * sin( time / 10.0 ) * 40.0 ) + tan( position.x * sin( time / 25.0 ) * 40.0 );
	color += cos( position.x * tan( time / 5.0 ) * 10.0 ) + sin( position.y * sin( time / 35.0 ) * 80.0 );
	color *= tan( time / 10.0 ) * 0.5;

	gl_FragColor = vec4( vec3( 0, 0.5, 1 ), 1.0 );

}