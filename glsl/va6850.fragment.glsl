#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 1.0;

	float color = 1.0;
	color += sin( position.x * cos( time / 2.0 ) * 3.0 ) + cos( position.y * cos( time / 5.0 ) * 8.0 );
	color += sin( position.y * sin( time / 13.0 ) * 21.0 ) + cos( position.x * sin( time / 34.0 ) * 55.0 );
	color += sin( position.x * sin( time / 89.0 ) * 144.0 ) + sin( position.y * sin( time / 233.0 ) * 377.0 );
	color *= sin( time / 610.0 ) * 0.987;

	gl_FragColor = vec4( vec3( color, color * 0.1597, sin( color + time / 2584.0 ) * 0.4181 ), 6765.0 );

}