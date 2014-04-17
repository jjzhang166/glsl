#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main(void) {
	vec2 pos = gl_FragCoord.xy;
	float ln = length(mouse.xy * resolution);
	float dx = pos.y * mouse.y / ln;
	float dy = pos.x * mouse.x / ln;

	float color = mod(((dx + dy) / length(mouse.xy)), 1.0);

	gl_FragColor = vec4(vec3(color), 1.0);
}