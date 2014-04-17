#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
varying vec2 surfacePosition;
float scale_x_min = -3.0;
float scale_x_max = 3.0;
float scale_y_min = -3.0;
float scale_y_max = 3.0;
const float max_iteration = 300.0;
	
void main( void ) {
	vec4 p = gl_FragCoord;
	float nx = surfacePosition.x;
	float ny = surfacePosition.y;
	float x = 0.0;
	float y = 0.0;
	float iteration = 0.0;
	for (float i = 0.0;i < max_iteration;i++) {
		if (x*x + y*y > 4.0){
			break;
		};
		float new_x = x*x - y*y + nx;
		float new_y = 2.0*x*y + ny;
		y = new_y;
		x = new_x;
		iteration = iteration+1.0;
	};
	float color = iteration*(1.0/max_iteration);
	
	gl_FragColor = vec4(color, color-0.1, color, 1.0);
}