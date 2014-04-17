#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec4 muster(vec2 pos) {
	return vec4(sin(pos.x * 200.0) * sin(pos.y * 200.0), 1.0, 1.0, 1.0);
}

float distanceSquared(vec2 pos1, vec2 pos2) {
	float xdif = pos2.x - pos1.x;
	float ydif = pos2.y - pos1.y;
	return xdif * xdif + ydif * ydif;
}

float dist(vec2 pos1, vec2 pos2) {
	return sqrt(distanceSquared(pos1, pos2));
}

void main( void ) {
	vec2 position = gl_FragCoord.xy;

	gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
	
	vec2 center = vec2(350.0, 200.0);
	vec2 f1 = center + vec2(0.0, -100.0);
	vec2 f2 = center + vec2(0.0, 100.0);
	

	if (dist(position, f1) + dist(position, f2) < 245.0) {
		gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);
	}
}