 #ifdef GL_ES
precision highp float;
#endif

const float ITERATIONS = 50.0;

uniform float time;
varying vec2 surfacePosition;

void main( void ) {
	vec2 c = 3.0*surfacePosition;
	vec2 z = c;
	
	for (int i = 0; i < int(ITERATIONS); i++) {
		if (i >= int(ITERATIONS / 2.0 * smoothstep(-1.0, 1.0, sin(time))))
			break;
		z = vec2(z.x*z.x - z.y*z.y, 2.0*z.x*z.y) + c;
	}

	if (sqrt(z.x*z.x + z.y*z.y) <= 2.0) {
		gl_FragColor = vec4(z.x, z.y, 1.0, 1.0);
	}
}