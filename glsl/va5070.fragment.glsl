#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = gl_FragCoord.xy / resolution - vec2( 0.5, 0.5 );
	
	vec3 color = vec3( 0.0, 0.0, 0.0 );
	
	float x = 20.0 * position.x;
	
	float y;
	y = sin( x );

	
	float diffY = abs( y - 10.0 * position.y);
	if( diffY < 0.1 ) {
		color = vec3( 1.0, 1.0, 1.0 );	
	}
	
	gl_FragColor = vec4( color, 1.0 );
	
}