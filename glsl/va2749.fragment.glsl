#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;

const vec2 MANDELBROT_START = vec2(-2.5, -1.0);
const vec2 MANDELBROT_END = vec2(1.0, 1.0);

const float MAX_ITERATIONS = 100.0;
const float INCREMENT = 1.0;
const float MAX_DISTANCE = 2.0;

void main( void ) {

	// Normalized pixel coordinate in range [0,1]
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	// Calculate starting values for Mandelbrot set for the pixel
        vec2 p0 = MANDELBROT_START + (MANDELBROT_END - MANDELBROT_START) * position;

	float shade = 0.0;
	
	// Mandelbrot loop.
	vec2 p = vec2(0.0, 0.0);
	for (float i = 0.0; i < MAX_ITERATIONS ; i += INCREMENT) {
	  if (distance(p.x, p.y) > MAX_DISTANCE) {
	    break;
	  }
	  float xtemp = p.x*p.x - p.y*p.y + p0.x;
	  p.y = 2.0*p.x*p.y + p0.y;
	  p.x = xtemp;

          shade = shade + 0.01;
	}
	
	gl_FragColor = vec4(shade, shade, 0.0, 1.0);
}