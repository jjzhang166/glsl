#ifdef GL_ES
precision lowp float;
#endif

const float depth = 256.0;
const float invDepth = 1.0 / depth;

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 pack(float value) {
	value *= depth;
	return vec2(floor(value) * invDepth, mod(value, 1.0));	
}

float unpack(vec2 value) {
	return value.x + value.y * invDepth;
}

void main(void) {
	vec2 pos = (gl_FragCoord.xy / resolution.xy);
	vec2 col = pack(pos.y);
	
	float yMax = 1.0;
	float yMin = 0.0;
	
	float y = unpack(col);
	y = yMin + y * (yMax - yMin);
	col = pack(y);
	
	gl_FragColor = vec4(col, 0.0, 1.0);
}