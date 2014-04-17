#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;

	float color = 0.0;
	color += sin( position.x * cos( time / 13.0 ) * 600.0 ) + cos( position.y * cos( time / 75.0 ) * 10.0 );
	color += sin( position.y * sin( time / 19.0 ) * 50.0 ) + cos( position.x * sin( time / 45.0 ) * 40.0 );
	color += sin( position.x * sin( time / 80.0 ) * 10.0 ) + sin( position.y * sin( time / 85.0 ) * 80.0 );
	color *= sin( time / 36.0 ) * 0.5;
	color += sin( position.x * cos( time / 3.0 ) * 75.0 ) + cos( position.x * cos( time / 80.0 ) * 35.0 );
  
	gl_FragColor = vec4( vec3( color, color * 0.5, sin( color + time / 3.0 ) * 0.75 ), 1.0 );

}