#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define ITERATIONS 100

int mandel(vec2 c) {
	vec2 z = vec2(0);
	
	for (int i = 0; i < ITERATIONS; i++) {
		z = vec2(z.x * z.x - z.y * z.y, 2.0 * z.x * z.y);
		z += c;
		
		if (length(z) > 2.0) {
			return i;
		}
	}
	
	return ITERATIONS;
}

void main( void ) {
	vec2 position = gl_FragCoord.xy / resolution;
	
	vec2 c = vec2(position.x * 3.0 - 1.0, position.y * 2.0 - 1.0);
	
	gl_FragColor = vec4(vec3(float(mandel(c)) / float(ITERATIONS)), 1.0);
}