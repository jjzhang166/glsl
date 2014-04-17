precision highp float;

uniform vec2 resolution;

float rand(float x, float magic) {
	return fract(sin(x) * magic);
}

void main() {
	vec2 p = gl_FragCoord.xy;
	vec3 a = vec3(rand(p.x, 43758.5453));
	vec3 b = vec3(rand(p.x, 12.345));
	gl_FragColor = vec4(mix(a, b, step(p.y / resolution.y, 0.5)), 1.0);
}
