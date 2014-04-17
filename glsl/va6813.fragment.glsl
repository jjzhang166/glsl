#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
varying vec2 surfacePosition;

void main( void ) {
	vec2 c = surfacePosition;
	vec2 z = c;
	
	for (int i = 0; i < 10000; i++) {
		z = vec2(z.x*z.x - z.y*z.y, 2.0*z.x*z.y) + c;
	}
	
	if (sqrt(z.x*z.x + z.y*z.y) <= 2.0) {
		gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);
	}
}