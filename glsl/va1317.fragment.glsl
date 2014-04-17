#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 fountain(vec2 p, float time) {
	vec3 point = vec3(p, 0);
	
	vec2 source = vec2(0.0, 0.0);
	
	vec3 black = vec3(0, 0, 0);
	vec3 color = vec3(1.0, 1.0, 1.0);

	return smoothstep(p.x, p.y, color);
}

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	
	vec3 c = fountain(uv, time);
	
	gl_FragColor = vec4(c, 1.0);
}