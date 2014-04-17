#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define ITERATIONS 512

void main( void ) {

	vec2 position = (gl_FragCoord.xy / resolution.xy );


	float pr = position.x * 3.0 - 2.0;
	float pi = position.y * 2.0 - 1.0;
	
	float cr = pr;
	float ci = pi;
	
	int iteration = 0;
	
	for (int i = 0 ; i < ITERATIONS; ++i) {
		float new_cr = cr * cr - ci * ci;
		float new_ci = 2.0 * cr * ci;
		cr = new_cr + pr;
		ci = new_ci + pi;
		iteration++;
		if (cr * cr + ci * ci >= 4.0) {
			break;
		}
	}

	float R = 0.0, G = 0.0, B = 0.0;
	
	if (iteration < ITERATIONS) {
		R = abs(cos(0.2 * float(iteration)));
		G = abs(sin(0.3 * float(iteration)));
		B = abs(sin(0.3 * float(iteration) + 3.14 / 4.0));
	}
	


	gl_FragColor = vec4(R,G,B,1.0);

}