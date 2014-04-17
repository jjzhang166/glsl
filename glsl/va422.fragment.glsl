// Set ----^ to 0.5 or 1 for more awesome
#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;


#define FREQ 0.2
vec4 color(float marker) {
	float r = 0.5 + sin(FREQ * marker + time * 3.0 / 8.0) / 2.0;
	float g = 0.5 + sin(FREQ * marker + time * 5.0 / 8.0) / 2.0;
	float b = 0.5 + sin(FREQ * marker + time * 7.0 / 8.0) / 2.0;
	return vec4(r, g, b, 1.0);
}

void main() {
	vec2 z, zT;
	z.x = 4.0 * (gl_FragCoord.x / resolution.x - 0.5);
	z.y = 3.0 * (gl_FragCoord.y / resolution.y - 0.5);

	int i;
	float F = 0.0;
	for(int i = 0; i < 50; i++) {
		zT.x = (z.x * z.x - z.y * z.y) + mouse.x;
		zT.y = (2.0 * z.y * z.x) + mouse.y;

		if(dot(zT,zT) > 4.0) break;
		z = zT;
		F += exp(-(dot(z,z)));
	}

	gl_FragColor = i == 50 ? vec4(0.0,0.0,0.0,1.0) : color(F);
}
