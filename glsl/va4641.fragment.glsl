#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

float scalexmin = -3.0;
float scalexmax = 3.0;
float scaleymin = -3.0;
float scaleymax = 3.0;
const float max_iteration = 100.0;
	
void main( void ) {
	float scalingnumberx = (scalexmax+-scalexmin)/resolution.x;//--calculate total scale of mandelbrot and divide it by the size
	float scalingnumbery = (scaleymax+-scaleymin)/resolution.y;//--calculate total scale of mandelbrot and divide it by the size
	float px = gl_FragCoord.x;
	float py = gl_FragCoord.y;
	float nx = scalingnumberx*px+scalexmin;//transform pixels scale to mandelbrot scale
	float ny = scalingnumbery*py+scaleymin;//transform pixels scale to mandelbrot scale
	float x = 0.0;
	float y = 0.0;
	float iteration = 0.0;
	for (float i = 0.0;i < max_iteration;i++) {
		if (x*x + y*y > 4.0){
			break;
		};
		float xtemp = x*x - y*y + nx;
		y = 2.0*x*y + ny;
		x = xtemp;
		iteration = iteration+1.0;
	};
	float color = iteration*(1.0/max_iteration);
	
	gl_FragColor = vec4(color, color, color, 1.0);
}