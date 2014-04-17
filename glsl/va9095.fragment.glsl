/* Colory TV Static demo "this one takes longer, and it looks trippier" */
#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse; /* yes, still mouse, but it makes it seem like a moving fractal*/
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse * 4.0;

	float color = 0.0;
	color += sin( position.x * cos( time / 157.0 ) * 80.0 ) + cos( position.y * cos( time / 10.0 ) * 100.0 );
	color += sin( position.y * sin( time / 100.0 ) * 40.0 ) + cos( position.x * sin( time / 25.0 ) * 400.0 );
	color += sin( position.x * sin( time / 500.0 ) * 100.0 ) + sin( position.y * sin( time / 30.0 ) * 800.0 );
	color *= sin( time / 1000.0 ) * 0.5;

	gl_FragColor = vec4( vec3( color, color * 9.5, sin( color + time / 3.0 ) * 3.75 ), 9.0 );
}