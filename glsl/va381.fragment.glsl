#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy); // / resolution.xy ) + mouse / 4.0;

	float color = 0.5;
	color += sin( position.x * cos( time / 14.0 ) * 80.0 ) + cos( position.y * cos( time / 14.0 ) * 14.0 );
	color += sin( position.y * sin( time / 40.0 ) * 40.0 ) + cos( position.x * sin( time / 40.0 ) * 40.0 );
	color += sin( position.x * sin( time / 5.0 ) * 10.0 ) + sin( position.y * sin( time / 55.0 ) * 80.0 );
	color *= sin( time / 10.0 ) * 0.1;

	gl_FragColor = vec4( vec3( color, color * 0., sin( color + time / 3.0 ) * 0.75 ), 1.0 );

}