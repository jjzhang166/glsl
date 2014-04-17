// Haha, Brett, be warned, this my be epilepsy inducing.

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;

	float color = 0.0;
	color += sin( position.x * cos( time / 15.0 ) * 250.0 ) + cos( position.y * cos( time / 7.0 ) * 10.0 );
	color += sin( position.y * sin( time / 10.0 ) * 20.0 ) + cos( position.x * sin( time / 15.0 ) * 40.0 );
	color += sin( position.x * sin( time / 5.0 ) * 500.0 ) + sin( position.y * sin( time / 35.0 ) * 80.0 );
	color *= sin( time / 10.0 ) * 0.5;
	
	float timeMod = mod(time, 10.0);
	
	if (timeMod < 2.0)
	{
		gl_FragColor = vec4( vec3( color * 0.2, color * 0.25, sin( color + time * 10.0) * 0.75 ), 1.0 );
	}
	else if (timeMod < 4.0)
	{
		gl_FragColor = vec4( vec3( 1.0 * sin(10.0 * time), color * 0.5, sin( color + time * 0.3 ) * 0.75 ), 1.0 );
	}
	else if (timeMod < 6.0)
	{
		gl_FragColor = vec4( vec3( time * color, color * 0.9, sin( color + time * 0.2 ) * 0.75 ), 1.0 );
	}
	else if (timeMod < 8.0)
	{
		gl_FragColor = vec4( vec3( sin(time * 10.0) * color, cos(time) * color * 0.25, sin( color + time / 2.0 ) * 0.75 ), 1.0 );
	}
	else
	{
		gl_FragColor = vec4( vec3( color, color * 0.4, sin( color + time * 10.0 ) * 0.75 ), 1.0 );
	}
}