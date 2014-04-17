#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 p = 2.0 * gl_FragCoord.xy / resolution.xy - 1.0;
	
	float r = 5.75 + sin( p.x ) * ( cos( 5.0  * p.x + time ) + sin( 7.0 * p.y - time ) + sin( time ) );
	float g = .25 + sin( p.y ) * ( cos( 3.0  * p.y + time ) + sin( 9.0 * p.x - time ) - cos( time ) );
	float b = 0.75 + sin( p.x ) * ( cos( 11.0 * p.x + time ) + sin( 3.0 * p.y + time ) + cos( time ) );
	
	gl_FragColor = vec4( r, g, b, 1.0 );

}