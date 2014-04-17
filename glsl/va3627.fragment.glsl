#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = (gl_FragCoord.xy / resolution.xy ) ;
	float r = 1.0;
	float g = 1.0;
	float b = 1.0;
	float color = 0.0;
	r = cos(position.y + time);
	color  = r * g * b;
	gl_FragColor = vec4( color, color, color, 1.0 );

}