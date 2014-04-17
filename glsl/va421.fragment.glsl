#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 resolution;

#define FREQ 0.2
vec4 color(float marker) {
	float r = (1.0 + sin(FREQ * marker + 3.0)) / 2.0;
	float g = (1.0 + sin(FREQ * marker + 5.0)) / 2.0;
	float b = (1.0 + sin(FREQ * marker + 7.0)) / 2.0;
	
	return vec4(r, g, b, 1.0);
}

#define ITERATIONS 50
#define SCALING 2.0
void main() {
	vec2 coord = gl_FragCoord.xy / resolution.xy;
	vec2 z, z0, zT;

	z0.x = 1.3333 * (coord.x - 0.5) * SCALING - 0.7;
	z0.y = (coord.y - 0.5) * SCALING;

	float F;
	for(int i = 0; i < ITERATIONS; i++) {
		if(dot(z,z) > 4.0) break;
		zT.x = (z.x * z.x - z.y * z.y) + z0.x;
		zT.y = (z.y * z.x + z.x * z.y) + z0.y;
		z = zT;
		F++;
	}
	gl_FragColor = (F == float(ITERATIONS)) ? vec4(0.0, 0.0, 0.0, 1.0) : color(F - log2(log2(dot(z,z))));
}
	