#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
varying vec2 surfacePosition;

const float MAXITERATIONS = 250.0;
const float CIRCLES_INCREMENT = 1.0; // This acts as the resolution that the fractal is rendered to. Small => High Res (default = 1.0)

// Use the mouse to pan and zoom.  Click 'hide code' first.

void main( void ) {
		
	float x0 = surfacePosition.x * 0.02 + 0.3258;
	float y0 = surfacePosition.y * 0.02 + 0.501;
	
	float x = 0.0;
	float y = 0.0;
	
	float count = 0.0;
	
	for (float i = 0.0; i < MAXITERATIONS; i += CIRCLES_INCREMENT){
		if (distance(x, y) > 2.0) {
			break;
		}
		
		float xtemp = pow(x, 2.0) - pow(y, 2.0);
		y = (2.0*x*y) + y0;
		x = xtemp + x0;
		count += CIRCLES_INCREMENT;
	}
	
	gl_FragColor = vec4(count*5.0/MAXITERATIONS, count*2.5/MAXITERATIONS, count/MAXITERATIONS, 1.0);
}