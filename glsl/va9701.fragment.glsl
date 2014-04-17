#ifdef GL_ES
precision mediump float;
#endif

uniform vec2  resolution;
uniform float time;
uniform vec2 mouse;

void main() {
	float size = 5.0;
	vec2 pos = resolution.xy * mouse;
	float dist = length(gl_FragCoord.xy - pos);
	float color = size / dist;
	gl_FragColor = vec4(vec2(color), sin(time)*0.5, 1.0);

	
}
