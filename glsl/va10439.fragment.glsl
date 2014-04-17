#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


void main( void ) {

	vec2 p = ( gl_PointCoord.xy );
	
	if (p.x > 0.99 && p.y < 0.99) {
		gl_FragColor = vec4(0,0,0, 1.0 );//border
	} else {
		gl_FragColor = vec4(1,1,1, 1.0 );
	}
	

}