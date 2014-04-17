#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define PI 3.141592653

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	float color = 0.0;
	
	if( position.y > 0.9 ) {
	} else if( position.y > 0.8 ) {
		color = sin( position.x*(2.0*PI) );	
	} else if ( position.y > 0.7 ) {
		color = cos( position.x*(2.0*PI) );
	} else if (position.y > 0.6 ) {
		float v = position.x*(2.0*PI);
		color = sin(v)*sin(v) + cos(v)*cos(v);
	}
	gl_FragColor = vec4( color);
}