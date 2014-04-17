
#ifdef GL_ES
precision highp float;
#endif
//Test
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = gl_FragCoord.xy / resolution.xy;

	float color = 0.0;
	color += 20.0 * sin( position.x * cos( time / 15.0 ) * 80.0 * -mouse.x / 2.0 ) + cos( position.y * cos( time / 10.0 ) * 10.0 );
	color *= sin( position.y * sin( time / 2.0 ) * 40.0 * mouse.y / 2.0) + cos( position.x * sin( time / 20.0 ) * 40.0 );
	color *= sin( position.x * sin( time / 5.0 ) * 10.0 ) + sin( position.y * sin( time / 15.0 ) * 80.0 );
	color *= sin( time / 10.0 ) * 0.5;

	gl_FragColor = vec4( vec3( color, color * 0.2, sin( color + time / 1.0 ) * 0.75 ), 1.0 );

}
		