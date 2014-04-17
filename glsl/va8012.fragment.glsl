#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy * 2.0) - 1.0;
	gl_FragColor = vec4((mod(atan(position.x + cos(time) * 0.2,position.y + sin(time) * 0.2) / 1.6, 0.1) * 10.0 + 0.5) * 0.6) * vec4(0.2, 0.5, 1.0, 1.0) * (1.5- length(position))
		* (length(vec2(position.x + cos(time) * 0.2, position.y + sin(time) * 0.2)));

}