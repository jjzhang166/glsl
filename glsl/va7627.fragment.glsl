#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;

	float color = 0.0;
	color += cos( position.x * cos( time / 25.0 ) * 80.0 ) + cos( position.y * cos( time / 15.0 ) * 10.0 );
	color += cos( position.y * sin( time / 15.0 ) * 45.0 ) + cos( position.x * sin( time / 25.0 ) * 40.0 );
	color += cos( position.x * sin( time / 5.0 ) * 10.0 ) + sin( position.y * sin( time / 35.0 ) * 80.0 );
	color *= cos( time / 50.0 ) * 0.1;

	gl_FragColor = vec4( vec3( color, color * 0.5, sin( color + time / 4.0 ) * 0.75 ), 2.0 );

}