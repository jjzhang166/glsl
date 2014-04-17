#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;

	float color = 0.0;
	color += sin( position.x * cos( time / 15.0 ) * 10.0 ) + cos( position.y * cos( time / 15.0 ) * 100.0 );
	color += sin( position.y * sin( time / 10.0 ) * 40.0 ) + cos( position.x * sin( time / 25.0 ) * 400.0 );
	color += sin( position.x * sin( time / 40.0 ) * 20.0 ) + sin( position.y * sin( time / 145.0 ) * 800.0 );
	color += (cos(dot(sin(position.x*time*0.4),1.0)),sin(cos(position.y*time*0.2)));
	color *= sin( time / 10.0 ) * 0.5;

	gl_FragColor = vec4( vec3( color, color * 0.8, sin( color + time / 4.0 ) * 2.75 ), 1.5 );

}