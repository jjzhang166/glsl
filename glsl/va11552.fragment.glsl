#ifdef GL_ES
#define TAU 6.28318
#define PI 3.141592
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

float onVertLine(float lineY, float lineH, float pointY) {
	float lineMaxY = lineY + lineH / 2.0;
	float lineMinY = lineY - lineH / 2.0;
	// pointY = lineMinY + lineH * t, 0 <= t <= 1
	// t = (pointY - lineMinY) lineH
	float t = (pointY - lineMinY) / lineH;
	return t >= 0.0 && t <= 1.0 ? t: 0.0;
}

vec4 colorForPoint(vec2 p) {
	vec4 color;
	float intensity;
	
	const float lineHeight = 2.0 / 64.0;
	const float lineSpacing = lineHeight * 3.0;
	const float center = 0.5;
	const float nLines = 3.0;
	const float nLinesHalf = nLines / 2.0;
	const float frequency = 8.0;
	const float amplitude = 2.0 / 64.0;
	float shift = time / 16.0;
	for (float i = -nLinesHalf; i < nLinesHalf; ++i) {
		float lineY = sin(TAU * (p.x + shift) * frequency) * amplitude;
		intensity += onVertLine(center + i * lineSpacing + lineY, lineHeight, p.y);
	}
	if (intensity > 0.0) {
		// 0-1 -> 0-1-0 sin
		intensity = sin(PI*intensity);
		vec3 colorT1 = vec3(1.0, 0.0, 0.0);
		vec3 colorT0 = vec3(0.0, 0.0, 0.0);
		vec3 colorTi = mix(colorT0, colorT1, intensity);
		color = vec4(colorTi, 1.0);
	}
	
	return color;
}

void main() {
	vec2 position = gl_FragCoord.xy / resolution.xy; // [0, 1]
	vec4 col = colorForPoint(position);
	gl_FragColor = col;
}