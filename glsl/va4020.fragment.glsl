// My own take on an old and little-known fractal called Hopalong.
// This version fixes some silly choices I made in the early versions.
// Now the hue and brighness indicate the angle and magnitude of the
// endpoint of the iteration relative to the start.
// Try panning and zooming with the mouse.
// hopalong@praxiq.com

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
varying vec2 surfacePosition;
uniform sampler2D backbuffer;

const float MAX_ITERATIONS = 700.0; // Set this from 400-4000 depending on performance. 
const vec2 START = vec2(18.0, 10.0);
const float BRIGHTNESS = 1.8;
const float SCALE = 50.; // The initial zoom.

// Stuff to play with:
float a = 1.; // Affects scale of features.
float b = 0.; // Affects amount of noisy areas.
float c = a*10.; // Ratio to a affects the size of the "bubbles."


float HueToRGB(float f1, float f2, float hue);
vec3 HSLToRGB(vec3 hsl);

void main( void ) {
	//Uncomment these to change the parameters with the mouse position.
	//a = mouse.y*40.; 
	//b = mouse.x*100.; 
	//c = mouse.x*10.*a;  

	vec2 p0 = START + surfacePosition * SCALE*a+c/2.;
	//vec3 lastPixel = texture2D(backbuffer, gl_FragCoord.xy / resolution).xyz;
	vec2 current = p0;
	vec2 next = p0;
	
	for (float i = 0.0; i <= MAX_ITERATIONS; i += 1.0) {
	  current = next;
	  next.x = current.y-sign(current.x)*sqrt(abs(a*current.x-b));
	  next.y = c - current.x;
	}
	
	vec3 pixel;
	float angle = dot(normalize(p0), normalize(current));
	angle = mod(angle+time/20., 1.0);
	float mag = length(current)/length(p0);
	pixel = HSLToRGB(vec3(angle, mag, mag*.4));

	gl_FragColor = vec4(pixel, 1.0);
			
}

// Stolen from somewhere on the web:
float HueToRGB(float f1, float f2, float hue)
{
	if (hue < 0.0)
		hue += 1.0;
	else if (hue > 1.0)
		hue -= 1.0;
	float res;
	if ((6.0 * hue) < 1.0)
		res = f1 + (f2 - f1) * 6.0 * hue;
	else if ((2.0 * hue) < 1.0)
		res = f2;
	else if ((3.0 * hue) < 2.0)
		res = f1 + (f2 - f1) * ((2.0 / 3.0) - hue) * 6.0;
	else
		res = f1;
	return res;
}

vec3 HSLToRGB(vec3 hsl)
{
	vec3 rgb;
	if (hsl.y == 0.0)
		rgb = vec3(hsl.z); // Luminance
	else
	{
		float f2;
		if (hsl.z < 0.5)
			f2 = hsl.z * (1.0 + hsl.y);
		else
			f2 = (hsl.z + hsl.y) - (hsl.y * hsl.z);
		float f1 = 2.0 * hsl.z - f2;		
		rgb.r = HueToRGB(f1, f2, hsl.x + (1.0/3.0));
		rgb.g = HueToRGB(f1, f2, hsl.x);
		rgb.b= HueToRGB(f1, f2, hsl.x - (1.0/3.0));
	}	
	return rgb;
}