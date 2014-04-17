// Sample of Lyapunov Space
// formula based on http://en.wikipedia.org/wiki/Lyapunov_fractal
// with some code from http://bstorage.com/Software/Lyapunov/
// Mostly almost working, sort of...

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define SEQUENCE_LENGTH 12
#define ITERATIONS 800
#define CONTRAST 0.8

const int skip_iterations = ITERATIONS / 10;

void main( void ) {
	vec2 position = ((gl_FragCoord.xy / resolution.xy) + vec2(2.1, 2.5)) * 1.0 + mouse;

	int index = 0;
	float rn, xn = 0.5, Lyapunov = 0.0, colorIntensity;
	for (int n = 0; n < ITERATIONS; ++n) {
		rn = (index < 6) ? position.x : position.y; // Choose X or Y for A or B.
		if (n >= skip_iterations) {
			Lyapunov += log2(abs(rn * (1.0 - 2.0 * xn)));
		}
		xn *= rn * (1.0 - xn);
		++index;
		if (index >= SEQUENCE_LENGTH) {
			index = 0;
		}
	}
	Lyapunov /= float(ITERATIONS - skip_iterations);

	if ((Lyapunov > 1e12) || (Lyapunov > 1e12)) {
		gl_FragColor = vec4(0.0, 0.0, 0.2, 1.0);
	} else if (Lyapunov > 0.0) {
		colorIntensity = exp(-Lyapunov);
		gl_FragColor = vec4(0.0, 0.0, 1.0 - colorIntensity, 1.0);
	} else {
		colorIntensity = pow(exp(Lyapunov), CONTRAST);
		gl_FragColor = vec4(colorIntensity, colorIntensity * 0.85, 0.0, 1.0);
	}
}
