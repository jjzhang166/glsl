// Simple center wipe-in effect by @bonnie_mathew

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = (gl_FragCoord.xy / resolution.xy ) ;
	vec2 center = vec2(0.5, 0.5);
	float length = length(position - center);
	float r = 1.0;
	float g = 1.0;
	float b = 1.0;
	float color = 7.0;
	r = cos(length + time);
	color  = r * g * b;
	gl_FragColor = vec4( color, color, color, 1.0 );

}