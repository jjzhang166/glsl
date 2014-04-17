//AMB 2012
#ifdef GL_ES
precision highp float;
#endif

uniform float time;
varying vec2 surfacePosition;
uniform vec2 resolution;
const float MAXITERATIONS = 100.0;
const float INCREMENT = 1.0;

/*
 *	- Use Left Mouse Button to move once you have clicked "hide code", and Right Mouse Button to Zoom
 *	- Zoom using the value below
 *	- Choose 1 from the dropdown menu above
 */

// User Variables ---------

const float 	START_ZOOM = 4.0; // Initial Zoom. Big => zoomed in;
const float 	SPEED = 5.0; // This is how fast the fractal becomes less "bloomed". Smaller => faster.
const vec2 	START = vec2(0.23, 0.501); // Starting coordinates

const vec3	COLOR_WEIGHT = vec3(4.0, 1.0, 2.0)/100.0; // Relative weights of the colours used in the fractal.
float 		flux ( void ) { return (sin(time)*0.07); } // This is used to fluctuate the colours

//-------------------------

void main( void ) {
	
	float bloom = 5.0; // "Bloom" acts as the inverse of fractal resolution. This value is how it will start. Smaller => Higher resolution.
	bloom -= (bloom - (time/SPEED) > 1.0 ? (time/SPEED) : 4.0);
		
	float x0 = surfacePosition.x / (START_ZOOM*((sin(time)*5.8)+6.2)) + START.x;
	float y0 = surfacePosition.y / (START_ZOOM*((sin(time)*5.8)+6.2)) + START.y;
	float x = 0.3+(sin(time)*0.125);
	float y = 0.2+(sin(time)*0.225);
	
	float count = 0.0;
	
	for (float i = 0.0; i < MAXITERATIONS; i += INCREMENT){
		
		if (distance(x, y) > 2.0) {break;}
		
		float xtemp = pow(x, 2.0) - pow(y, 2.0);
		y = (2.0*x*y) + y0;
		x = xtemp + x0;
		count += bloom;
		
	}
	
	gl_FragColor = vec4(count*COLOR_WEIGHT.r+flux(), count*COLOR_WEIGHT.g+flux(), count*COLOR_WEIGHT.b+flux(), 1.0);
}