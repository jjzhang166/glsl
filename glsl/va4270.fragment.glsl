#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 8.0;

	vec4 color = vec4(position.x, position.y, 1, 1);
	gl_FragColor = color;
}