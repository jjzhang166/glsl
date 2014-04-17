#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;

	float color = 0.0;
	color += sin( position.x * cos( time / 2.0 ) * 80.0 ) + cos( position.y * asin( time / 5.0 ) * 10.0 );
	color += cos( position.y * sin( time / 1.0 ) * 20.0 ) + acos( position.x * sin( time / 51.0 ) * 5.0 );
	color += sin( position.x * sin( time / 1.0 ) * 10.0 ) + cos( position.y * asin( time / 15.0 ) * 10.0 );
	color *= sin( time / 60.0 ) * 0.5;

	gl_FragColor = vec4( vec3( color, color * 0.2, sin( color + time / 10.0 ) * .3 ), 1 );

}