#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) - mouse;
	float distance = position[0]*position[0]+position[1]*position[1];
	float color = 0.01/distance;

	gl_FragColor = vec4( color, color , color , 1.0 );

}