#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = gl_FragCoord.xy / resolution - vec2( 0.5, 0.5 );
	
	vec3 color = vec3( 0.0, 0.0, 0.0 );
	
	float x = 20.0 * mouse.x * position.x;
	
	float y;
	// Define function to plot here.
	//y = sin( x );
	//y = cos( x );
	//y = tan( x );
	y = sin( x ) + 2.0 * cos( 15.0 * x +time) + cos( 50.5 * x +time*10.);
	//y = x;
	//y = fract( x );
	//y = mod( x, 2.0 );
	//y = sqrt( x );
	//y = x * x;
	
	float diffY = abs( y - 10.0 * position.y / mouse.y );
	if( diffY < 0.1 ) {
		color = vec3( 1.0, 1.0, 1.0 );	
	}
	
	gl_FragColor = vec4( color, 1.0 );
	
}