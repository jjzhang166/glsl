#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// For those of you just starting out with this, here is an explanation of a simple circle. Hope it helps.
// countfrolic@gmail.com
// Added: Introduction to signed distance

float Circle(vec2 uv, vec2 pos, float radius) {
	float d = distance(pos, uv);		// Distance from the center
	d -= radius;				// Signed distance to edge of Circle
	d *= resolution.y;			// Scale distance by resolution : So 1.0 is the distance covered by 1 pixel
	return d;
}

void main( void ) {
	
	const float edgeWidth = 5.;
	
							// GL Fragcoord is a supplied x, y coordinate going from 0, 0 to <pixelwidth of the window>, <pixelHeight of the window>
	
	vec2 uv = ( gl_FragCoord.xy / resolution.xy ); // divide fragcoord by resolution to get a coordinate in the 0 to 1 range. (0,0) being the bottom left pixel and (1,1) the top right
	uv -= vec2(0.5); 				// shift the coordinates so that (0, 0) is in the center of the screen. Now the coordinates go from (-0.5, -0.5) to (0.5, 0.5)
	
							// Right now both x and y coordinates have the same range, even though the display window might not be square
	float aspectRatio = resolution.x/resolution.y;	// To correct for that, we calculate the aspect ratio of the screen (width/height)...
	uv.x *= aspectRatio;				// .. and multiply the x component of the coordinate
							// if you don't do this, your circle will look like an ellipse if your display window is not exactly square.
	
	vec2 correctedMouse = mouse-0.5;		// Because we want the circle to display right underneath the mouse coordinate
	correctedMouse.x *= aspectRatio;		// we have to apply the same transformations to the mouse coordinate as we did for the uv coordinate
	
	vec3 backgroundColor = vec3(0, 0, 1);		// Set the backgrounbd color to dark green
	
	float circleRadius = (sin(time) + 1.4)*0.03;	// make the circleradius fluctuate 
	
	float signedDistance = Circle(uv, correctedMouse, circleRadius);// This function will return the signed distance to the edge of the circle (in pixel unit), negative inside, positive outside, 0 on the edge
	
	float circleMask = signedDistance;
	
	// Comment this out the render a circle, not a disk
	//circleMask = abs(signedDistance)-edgeWidth;	// Taking the absolute value will turn negative distance (inside the circle) to positive, rendering a circle 
	
	vec3 circleColor = vec3(1, 1, 1);		// Define a circle color with RGB values, this one is red (1 for red, 0 for green and 0 for blue)
	
	vec3 color = mix(backgroundColor, circleColor, circleMask);	// Use the circleMask variable to blend between the circleColor and the backgroundColor;
									// The mix function does a linear interpolation
									// mix does the same as this   color = (1.-circleMask)*backgroundColor + circleMask*circleColor;
	
	gl_FragColor = vec4(color, 1);			// The shader expects an RGBA value, so we create one with 'color' as our color (RGB) componenet and 1 as our alpha component
}