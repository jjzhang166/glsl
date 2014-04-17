// DFT explanation

#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.1415926535897932384626433832795028841971693993751058

// change me - sinusoids are of frequency 12, 4 and 8
#define ITERATIONS 20

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float wbsin(float x) {
	return (sin(x * 2.0 * PI) + 1.0) / 2.0;
}

float polar(float x, float mag) {
	float sum = 0.0;
	float s = 1.0 + mod(time * 0.1, 11.0);
	for (int i = 0; i < ITERATIONS; i++) {
		x++;
		float rx = x / s;
		float y = (wbsin(rx * 12.0) + wbsin(rx * 4.0 + 0.5) * 3.0 + wbsin(rx * 8.0 + 0.3) * 2.0);
		
		sum += float(abs(y - mag) < 0.1);
	}
	return sum / float(ITERATIONS);
}

void main( void ) {

	vec2 position = (gl_FragCoord.xy / resolution );

	position -= vec2(0.5, 0.5);
	
	position.x *= resolution.x / resolution.y;
	
	float mag = length(position) * 10.0;
	float x = (atan(position.y, position.x) / PI + 1.0) / 2.0;
	
	gl_FragColor = vec4(0.0, polar(x, mag), 0.0, 1.0);
}