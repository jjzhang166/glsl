#ifdef GL_ES
precision mediump float;
#endif

#define GAP 3.0
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main (void) {
	vec2 position = gl_FragCoord.xy;
	gl_FragColor = vec4(cos(time * position.y) / 2.0 + 0.5, sin(time * position.x) / 2.0 + 0.5, cos(time) * sin(time + 1.0), 1.0);
}