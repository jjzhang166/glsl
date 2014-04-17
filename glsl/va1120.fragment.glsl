#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = (gl_FragCoord.xy / resolution + mouse * 0.5 - 0.75) * vec2(32.0,4.0);
	position.x *= resolution.x / resolution.y;
	
	float color = sin(position.x / (tan(position.y)));

	gl_FragColor = vec4( color, color, -color, 1.0 );

}