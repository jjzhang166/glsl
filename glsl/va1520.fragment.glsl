#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	gl_FragColor = vec4(vec3(1.0 - distance((gl_FragCoord.xy / resolution.xy), vec2(0.5, 0.5)) / 0.25) * abs(sin(time)), 1.0);
}