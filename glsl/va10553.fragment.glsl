#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
#define M_PI 3.1415926535897932384626433832795

void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xy ) - vec2(.5,.5);
	float angle = atan(position.x,position.y)-(time*.2);
	float l = distance(position,vec2(0,0));
	angle += l*(sin(time));
	float color = 0.0;
	if ( mod(angle, M_PI/10.0) < M_PI/20.0 ) color = pow(l*10.0,0.4)-1.0;
	
	gl_FragColor = vec4( color, color, color, 1.0 );
}