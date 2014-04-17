// Message for author of http://glsl.heroku.com/e#9700.0

// Hi, thanks for hacking on my shader. I was having real trouble with the zoom coordinates until you came along
// I've had a go at smoothing the zoom, take a look at subPixel.
// I'm not sure what's causing the horizontal and vertical lines from the mouse position
// You can catch me at https://twitter.com/tdhooper

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

vec3 RGBToHSL(vec3 color)
{
vec3 hsl; // init to 0 to avoid warnings ? (and reverse if + remove first part)

float fmin = min(min(color.r, color.g), color.b); //Min. value of RGB
float fmax = max(max(color.r, color.g), color.b); //Max. value of RGB
float delta = fmax - fmin; //Delta RGB value

hsl.z = (fmax + fmin) / 2.0; // Luminance

if (delta == 0.0)	 //This is a gray, no chroma...
{
hsl.x = 0.0;	// Hue
hsl.y = 0.0;	// Saturation
}
else //Chromatic data...
{
if (hsl.z < 0.5)
hsl.y = delta / (fmax + fmin); // Saturation
else
hsl.y = delta / (2.0 - fmax - fmin); // Saturation

float deltaR = (((fmax - color.r) / 6.0) + (delta / 2.0)) / delta;
float deltaG = (((fmax - color.g) / 6.0) + (delta / 2.0)) / delta;
float deltaB = (((fmax - color.b) / 6.0) + (delta / 2.0)) / delta;

if (color.r == fmax )
hsl.x = deltaB - deltaG; // Hue
else if (color.g == fmax)
hsl.x = (1.0 / 3.0) + deltaR - deltaB; // Hue
else if (color.b == fmax)
hsl.x = (2.0 / 3.0) + deltaG - deltaR; // Hue

if (hsl.x < 0.0)
hsl.x += 1.0; // Hue
else if (hsl.x > 1.0)
hsl.x -= 1.0; // Hue
}

return hsl;

}

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

vec3 nrand3( vec2 co )
{
    vec3 a = fract( cos( co.x*8.3e-3 + co.y )*vec3(1.3e5, 4.7e5, 2.9e5) );
    vec3 b = fract( sin( co.x*0.3e-3 + co.y )*vec3(8.1e5, 1.0e5, 0.1e5) );
    vec3 c = mix(a, b, 0.5);
    return c;
}

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

vec4 subPixel(sampler2D source, vec2 coords) {
	coords = coords * resolution.xy;
	
	float x = floor(coords.x - 0.5) + 0.5;
	float y = floor(coords.y - 0.5) + 0.5;
	
	vec4 pixel         = texture2D(source, vec2(x, y) / resolution.xy);
	vec4 pixelRight    = texture2D(source, vec2(x + 1.0, y) / resolution.xy);
	vec4 pixelTop      = texture2D(source, vec2(x, y + 1.0) / resolution.xy);
	vec4 pixelTopRight = texture2D(source, vec2(x + 1.0, y + 1.0) / resolution.xy);
	
	float xFraction = coords.x - x;
	float yFraction = coords.y - y;
	
	float pixelFull = (1.0 + xFraction) * (1.0 + yFraction);
	
	vec4 colour = pixel * (1.0 / pixelFull)
		    + pixelRight * (xFraction / pixelFull)
		    + pixelTop * (yFraction / pixelFull)
		    + pixelTopRight * ((yFraction * xFraction) / pixelFull);
	
	
	return colour;
}

vec4 averageForRadius(vec2 co, float radius) {
    vec4 average = vec4(0);
    
    float sampleSize = 1.0;

    int n = 0;
    float y2 = 0.0;
    float x2;
    float x3;

    for (int i = 0; i < 50; i++) {
        if (y2 > radius) break;

	x2 = sqrt(pow(radius, 2.0) - pow(y2, 2.0));
        x3 = (x2 - sampleSize) * -1.0;
    
	for (int k = 0; k < 50; k++) {
            if (x3 >= x2) break;
            n++;
            if (y2 != 0.0) {
                n++;
            }
            x3 += sampleSize;   
        }
        y2 += sampleSize;    
    }

    y2 = 0.0;
    float fraction = 1.0 / float(n);
    n = 0;
    	
    for (int i = 0; i < 50; i++) {
        if (y2 > radius) break;
	    
        x2 = sqrt(pow(radius, 2.0) - pow(y2, 2.0));
        x3 = (x2 - sampleSize) * -1.0;
        
        for (int k = 0; k < 50; k++) {
            if (x3 >= x2) break;
            
            vec2 spoint = vec2(x3 / resolution.x, y2 / resolution.y);
	    vec4 col = texture2D(backbuffer, co + spoint);
            average += col * fraction;
            
            if (y2 != 0.0) {
                vec2 spoint = vec2(x3 / resolution.x, y2 / resolution.y * -1.0);
		vec4 col = texture2D(backbuffer, co + spoint);
                average += col * fraction;
                n++;
            }
            
            x3 += sampleSize;   
        }

        y2 += sampleSize;    
    }
	
    return average;
}

void main( void ) 
{
    float substrate = 0.0;
    vec3 fill;
	vec2 position = gl_FragCoord.xy/resolution;
		
	vec4 originalFill = averageForRadius(mouse, 3.0);
	
	//originalFill = texture2D(backbuffer, mouse);
	vec3 fillHSL = RGBToHSL(vec3(originalFill.r, originalFill.g, originalFill.b));
		
	    
	fillHSL = vec3(fillHSL.r, 1.0, 0.5);
	
		
	vec3 fillRGB = HSLToRGB(fillHSL);
	fill = fillRGB;
	//    fill = vec3(originalFill.r, originalFill.g, originalFill.b);
	    
    
	
    if (position.x < 0.2) {
	 fill = HSLToRGB(vec3(position.y, 1.0, 0.1));
    }

    //gl_FragColor = vec4(fill.r, fill.g, fill.b, substrate);
    gl_FragColor = vec4(fill.r, fill.g, fill.b, 1.0);
}
