#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 1.0;

	float color = sin(time/10.0)+cos(time/10.0);
	//color += sin( position.x * cos( time / 15.0 ) * 80.0 ) + cos( position.y * cos( time / 15.0 ) * 10.0 );
	//color += sin( position.y * sin( time / 10.0 ) * 40.0 ) + cos( position.x * sin( time / 25.0 ) * 40.0 );
	//color += sin( position.x * cos( time / 5.0 ) * 10.0 ) + sin( position.y * sin( time / 35.0 ) * 80.0 );
	//color *= cos( time / 10.0 ) * 0.6;
	

	gl_FragColor = vec4( vec3( sin(position.x+time/10.0)*0.5, cos(position.y+time/10.0) * 0.5, sin( color * time ) * 0.1 ), 1.1 );

}