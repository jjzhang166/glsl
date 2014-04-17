#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {	
	
	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	float color = 0.0;
	color += cos( (position.x - 5.0) * cos( time / 15.0 ) * 20.0  + cos( position.y ) * 10.0 );
	color -= cos( position.y * cos( time / 10.0 ) * 40.0  + cos( position.x ) * 40.0 );
	color += cos( position.x * cos( time / 5.0 ) * 10.0 + cos( position.y ) * 80.0 );
	color *= cos( time / 10.0 ) * 0.5;

	gl_FragColor = vec4( vec3( color, 100, sin( color ) * 0.75 ), 1 );

}