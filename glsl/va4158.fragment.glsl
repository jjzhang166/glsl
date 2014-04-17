#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 p = 6.0 * gl_FragCoord.xy / resolution.xy - 1.0;
	
	float r = 0.75 + sin( p.x ) * ( cos( 5.0  * p.x + time ) + sin( 7.0 * p.y - time ) + sin( time ) );
	float g = 0.25 + sin( p.y ) * ( cos( 3.0  * p.y + time ) + sin( 9.0 * p.x - time ) - cos( time ) );
	float b = 0.75 + sin( p.x ) * ( cos( 11.0 * p.x + time ) + sin( 3.0 * p.y + time ) + cos( time ) );
	
	float h = (r + g + b) / 20.0 + 0.3;
	
	gl_FragColor = vec4( h, h, h, 1.0 );

}