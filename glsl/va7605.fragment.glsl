#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	// returns current fragment position as 0-1 with 0,0 at bottom-left & 1,1 at top-right
	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	// returns distance between fragment and mouse
	// between 0,0 when mouse is on top of fragment 
	// to 1,1 when mouse is across from fragment
	float dist = length(position - mouse) ;
	// reduce the size of the glow
//	dist *= sin(time) * 50.0;
	dist *= 10.0;
	// invert the colors
	vec3 color = vec3(0.25 - dist, 0.15 - dist, 1.0 - dist);

	gl_FragColor = vec4( color, 1.0 );

}
