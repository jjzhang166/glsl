#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 pos = gl_FragCoord.xy / resolution.xy;
	gl_FragColor = vec4(pos.x, pos.y, 0.0,1.0);
}