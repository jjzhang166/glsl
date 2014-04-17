#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;

	float color = 2.0;
	color += tan( position.x * cos( time / 01.0 ) * 80.0 ) + cos( position.y * cos( time / 7.8 ) * 8.0 );
	color += tan( position.y * tan( time / 01.0 ) * 100.0 ) + tan( position.x * cos( time / 72.0 ) * 08.0 );
	color += sin( position.x * sin( time / 5.0 ) * 10.0 ) + sin( position.y * cos( time / 72.0 ) * 10.0 );
	color *= sin( time / 10.0 ) * 0.5;

	gl_FragColor = vec4( vec3( color, color * 0.5, sin( color + time / 3.0 ) * 0.75 ), 1.0 );

}