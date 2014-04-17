#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	float d = sqrt(position.x * position.x + position.y * position.y );
	
	
	float e = -1.0;
	if( d < sin(time) )
		e = -e;
	if( d < cos(time) )
		e = -e;
	
	if( e == 1.0 )
		gl_FragColor = vec4( 0.75, 0.75, 0.75, 1.0 );
	else 
		gl_FragColor = vec4(1.0);	
		
	
	/*
	if( d < 1.0 && d > 0.5)
		gl_FragColor = vec4( 0.75, 0.75, 0.75, 1.0 );
	else 
		gl_FragColor = vec4(1.0);
	*/

}