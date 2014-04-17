#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
varying vec2 surfacePosition;

const vec2 MANDELBROT_START = vec2(-0.6, 0.0);

const float MAX_ITERATIONS = 100.0;
const float MAX_DISTANCE = 15.0;
const float INCREMENT = 1.0;

void main( void ) {

	// Normalized pixel coordinate in range [0,1]
	// Calculate starting values for Mandelbrot set for the pixel
        vec2 p0 = MANDELBROT_START + surfacePosition * 2.5;

	float shade = 0.0;
	
	float currentDistance = mouse.x * MAX_DISTANCE;
	
	// Mandelbrot loop.
	vec2 p = vec2(0.0, 0.0);
	for (float i = 0.0; i < MAX_ITERATIONS ; i += INCREMENT) {
	  if ((p.x*p.x+p.y*p.y) > currentDistance) {
	    break;
	  }
	  p = vec2(p.x*p.x - p.y*p.y + p0.x, 2.0*p.x*p.y + p0.y);

          shade += 1.0;
	}
	shade /= MAX_ITERATIONS;
	
	gl_FragColor = vec4(shade, shade, 0.0, 1.0);
	
	// Progress bar at the bottom.
	if ((gl_FragCoord.y <= 7.0) && (gl_FragCoord.x / resolution.x < currentDistance / MAX_DISTANCE)) {
	  gl_FragColor.gb = vec2(0.7, 0.9);
	}
}