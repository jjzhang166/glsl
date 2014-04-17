#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	float color = 0.0;
	color += (1.0 / distance( position, vec2( 0.5, 0.5 ) ))*0.1;

	gl_FragColor = vec4( color*0.5, color, color, 1.0 );

}