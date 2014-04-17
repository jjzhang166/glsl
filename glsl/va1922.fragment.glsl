#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;

#define FREQ 1.0
vec4 color(float marker) {
	float r = (1.0 + sin(FREQ * marker)) / 2.0;
	float g = (1.0 + cos(FREQ * marker)) / 2.0;
	float b = (1.0 + sin(-FREQ * marker)) / 2.0;
	
	return vec4(r, g, b, 1.0);
}

#define ITERATIONS 100
#define SCALING 2.0
#define TIMEFACTOR 0.2
void main() {
	vec2 coord = gl_FragCoord.xy / resolution.xy;
	vec2 z, z0, zT;
	float scaledTime = TIMEFACTOR * time;

	vec2 intermediate = vec2(sin(scaledTime/2.0), cos(scaledTime/2.0));
	z0.x = 1.3333 * (coord.x - 0.5) * (SCALING + intermediate.x*SCALING) - (SCALING*mouse.x);
	z0.y = (coord.y - 0.5) * (SCALING + intermediate.x*SCALING) - (SCALING*mouse.y);
	z0.xy *= (vec2(abs(intermediate.y), -abs(intermediate.y)));

	float F;
	for(int i = 0; i < ITERATIONS; i++) {
		if(dot(z,z) > 9.5) break;
		zT.x = (z.x * z.x - z.y * z.y) + z0.x;
		zT.y = (z.y * z.x + z.x * z.y) + z0.y;
		z = zT;
		F++;
	}
	vec4 col = color(time + F - log2(log2(dot(z,z))));
	gl_FragColor = (F == float(100)) ? mix(vec4(0.0, 0.0, 0.0, 1.0), col, 0.5) : col;
}
	