#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse * 8.0;

	float color = 0.0;
	color += sin( position.x * cos( time / 1678.0 ) * 80.0 ) + sin( position.y * cos( time / 685.0 ) * 10.0 );
	color += sin( position.y * sin( time / 1768678.0 ) * 40.0 ) + sin( position.x * sin( time / 6865.0 ) * 40.0 );
	color += sin( position.x * sin( time / 678.0 ) * 10.0 ) + sin( position.x * sin( time / 665.0 ) * 80.0 );
	color *= sin( time / 440.0 ) * 0.5;

	gl_FragColor = vec4( vec3( color, color * 4.5, sin( color + time / 2.0 ) * 0.75 ), 1.0 );

}