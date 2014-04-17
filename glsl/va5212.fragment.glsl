#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;

	float color = 0.0;
	color *= cos( position.x * gl_FragCoord.x * cos( time / 15.0 ) * 80.0 ) + cos( position.y * cos( time / 115.0 ) * 10.0 );
	color += cos( position.y / cos( time / 10.0 ) / 46.0 ) + cos( position.x * sin( time / 25.0 ) * 40.0 );
	color *= cos( position.x * cos( time / 50.0 ) * 10.0 ) + sin( position.y * sin( time / 35.0 ) * 80.0 );
	color /= cos( time / 10.0 ) / 0.5;

	gl_FragColor = vec4(vec3(cos( color - time / 2.0 ) , cos( color + time / 1.0 ), cos( color + time / 3.0 ) * 2.75 ), 0.5 );

}