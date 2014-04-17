#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
varying vec2 surfacePosition;

const int max_iteration = 2048;

void main( void ) {
	
	vec2 position = surfacePosition * 2.0 - vec2(0.5, 0.0);
	
	float x0 = position.x;
	float y0 = position.y;
	float x  = 0.0;
	float y  = 0.0;
	float iteration = 0.0;
	
	for (int i = 0; i < max_iteration; ++i) {
		
		float xx = x*x;
		float yy = y*y;
		
		if (xx + yy > 4.0) {
			iteration = float(i) + 1.0 - log(log(sqrt(xx + yy))) / log(2.0);
			break;
		}
		float xtemp = xx - yy + x0;
		y = 2.0*x*y + y0;
		x = xtemp;
	}
	float color = 3.0*pow(iteration, 0.4) / 21.112127;
	
	gl_FragColor = vec4(clamp(color, 0.0, 1.0), clamp(color - 1.0, 0.0, 1.0), clamp(color - 2.0, 0.0, 1.0), 1.0);
}