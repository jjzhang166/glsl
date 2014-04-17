#ifdef GL_ES
precision lowp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define PI 3.14159265358979323

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) * 2.0 - 1.0;

	float color = mod(atan( position.x, position.y) / ( .625 * sin( time / 2. ) ), 1.5 ) * 3.;
	gl_FragColor = vec4( color, color / 10., color / 5., 1. );
}