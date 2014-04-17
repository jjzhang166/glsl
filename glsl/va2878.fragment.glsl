// My own take on an old and little-known fractal called Hopalong.
// This version adds (even more) psychedelic colors by rotating hues.
// hopalong@praxiq.com

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
varying vec2 surfacePosition;
uniform sampler2D backbuffer;

const vec2 START = vec2(0.0, 0.0);
const float MAX_ITERATIONS = 700.0;
const float BRIGHTNESS = 1.8;
const float SCALE = 15.; // The initial zoom.

// Stuff to play with:
// By default, the values set here for a and c are overriden in main() by the mouse coordinates.
const bool HSL = true; // do you want crazy colors, or crazier colors?
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
	
	vec3 pixel;
	if(HSL){
	  float angle = dot(vec2(sin(time/2.), cos(time/2.)), normalize(current));
	  float mag = length(current);
	  pixel = HSLToRGB(vec3(angle, mag/colorscale, mag/colorscale*.5));
	} else {
	  pixel = vec3(current.x/colorscale, current.y/colorscale, (next.y-current.y)/colorscale);
	}

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