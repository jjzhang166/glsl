#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;

	float color = 0.0;
	color += sin( position.x * cos( time / 7777.0 ) * 850.0 ) + cos( position.y * cos( time / 165.0 ) * 170.0 );
	//color += sin( position.y * sin( time / 150.0 ) * 460.0 ) + cos( position.x * sin( time / 265.0 ) * 450.0 );
	//color += sin( position.x * sin( time / 56.0 ) * 150.0 ) + sin( position.y * sin( time / 365.0 ) * 780.0 );
	//color *= sin( time / 999910.0 ) * 67.5;

	gl_FragColor = vec4( vec3( color, color * 769.5, sin( color + time / 656.0 ) * 39.75 ), 19.0 );

}