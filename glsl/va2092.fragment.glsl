#ifdef GL_ES
precision lowp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define PI 3.14159265358979323

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) * 2.0 - 1.0;

	float color = (atan( position.y, position.x ) / ( 2.0 * sin( time ) ) / acos(-1.)) * .5 + .5;
	gl_FragColor = vec4( color / 2.0, color / 3.0, color, 1.0 );
}