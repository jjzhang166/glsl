// My own take on an old and little-known fractal called Hopalong.
// It's gorgeous if you set the resolution to 0.5 in the pop-up menu above.
// hopalong@praxiq.com

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
varying vec2 surfacePosition;
//uniform sampler2D backbuffer;

const vec2 START = vec2(20.0, 20.0);
const float MAX_ITERATIONS = 700.0;
const float BRIGHTNESS = 1.8;
const float SCALE = 15.; // The initial zoom.

// Stuff to play with:
// By default, the values set here for a and c are overriden in main() by the mouse coordinates.
float a = 2.; // Affects scale of features.
float b = 5.; // Affects amount of noisy areas.
float c = 1.; // Affects the size of the "bubbles."


float HueToRGB(float f1, float f2, float hue);
vec3 HSLToRGB(vec3 hsl);

void main( void ) {
	a = mouse.y*40.; 
	//b = mouse.x*100.; 
	c = mouse.x*10.*a;  
	float colorscale = BRIGHTNESS*SCALE*a*length(surfacePosition);
	//float colorscale = SCALE*a*sqrt(length(surfacePosition));

	vec2 p0 = START + surfacePosition * SCALE*a+c/2.;
	//vec3 lastPixel = texture2D(backbuffer, gl_FragCoord.xy / resolution).xyz;
	vec2 current = p0;
	vec2 next = p0;
	
	for (float i = 0.0; i <= MAX_ITERATIONS; i += 1.0) {
	  current = next;
	  next.x = current.y-sign(current.x)*sqrt(abs(a*current.x-b));
	  next.y = c - current.x;
	}
	
	// I'm not sure why this coloring algorithm works as well as it does!
	vec3 pixel = vec3(current.x/colorscale, current.y/colorscale, (next.y-current.y)/colorscale);
	gl_FragColor = vec4(pixel, 1.0);
			
}
