// Chessboard Zoomer ;)

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 p = ( gl_FragCoord.xy / resolution.xy ); 

	float color = 0.0;
	
	vec2 t = p* 1.5/sin(time/8.); 
	if( mod(t.x, 1.9) > 1. == mod(t.y, 1.9) > 1.0 )
		color = 1.; 
	else 
		color = 0.; 
	
	gl_FragColor = vec4( color, 1.0, 1.0, 1.0 );

}