#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	
	vec2 oval = vec2( cos(time)/5.0, sin(time)/5.0 ) + vec2( .5, .5 );
	
	if( distance( position, oval ) < .05 ) {
		gl_FragColor = vec4( 1.0, 1.0, 1.0, 1.0 );	
	}

}