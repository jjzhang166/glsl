#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.1415926535897932384626433832795

// "Positive sin"
#define psin(x) (sin(x)+1.0)/2.0

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	float colour = 0.0;
	colour = (mod(position.x, 2.0) + mod(position.y, 2.0));

	gl_FragColor = vec4( psin(time + PI/1.5)*colour, psin(time + 2.0*PI/1.5) * colour, psin(time)*colour, 1.0 );
}