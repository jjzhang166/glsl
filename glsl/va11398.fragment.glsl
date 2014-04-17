#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	float color = 1.0;
	color += sin( position.x * cos( time / 5.0 ) * 30.0 ) + sin( position.y * cos( time / 100.0 ) * 100.0 );
	color += sin( position.x * cos( time / 100.0 ) * 100.0 ) + cos( position.y * sin( time / 10.0 ) * 15.0 );
		
	gl_FragColor = vec4(color * .2, color * .4, color * .4, 1.0);
}