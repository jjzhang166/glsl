#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const int ITERATIONS = 200;
void main( void ) {

	vec2 position = 3.0 * ( gl_FragCoord.xy / resolution.y ) - 1.5;

	vec2 z = position;
	vec2 c = 3.0 * (mouse) - 1.5;
	float color;
	for (int i = 0; i < ITERATIONS; i++) {
		z = vec2(z.x*z.x - z.y*z.y, 2.0*z.x*z.y) + c;
		if ((z.x*z.x + z.y*z.y) > 2.0) {
			color = sqrt(20.0*float(i)/float(ITERATIONS));
			break;
		}
		color = 0.0;
	}
	
	gl_FragColor = vec4( 0.7*color, 0.5*color, 0.9*color, 1.0 );

}