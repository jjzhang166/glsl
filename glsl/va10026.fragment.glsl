// https://twitter.com/tdhooper
// inspired by http://www.fabianoefner.com/64838/556924/projects/millefiori

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

int numPointsForRadius(int r) {
	if (r == 3) return 21;
	if (r == 5) return 69;
}
vec2 pointForRadius(int r, int i) {
	if (r == 3) {
		if (i == 0) return vec2(-2, 0);
		if (i == 1) return vec2(-1, 0);
		if (i == 2) return vec2(0, 0);
		if (i == 3) return vec2(1, 0);
		if (i == 4) return vec2(2, 0);
		if (i == 5) return vec2(-2, 1);
		if (i == 6) return vec2(-2, -1);
		if (i == 7) return vec2(-1, 1);
		if (i == 8) return vec2(-1, -1);
		if (i == 9) return vec2(0, 1);
		if (i == 10) return vec2(0, -1);
		if (i == 11) return vec2(1, 1);
		if (i == 12) return vec2(1, -1);
		if (i == 13) return vec2(2, 1);
		if (i == 14) return vec2(2, -1);
		if (i == 15) return vec2(-1, 2);
		if (i == 16) return vec2(-1, -2);
		if (i == 17) return vec2(0, 2);
		if (i == 18) return vec2(0, -2);
		if (i == 19) return vec2(1, 2);
		if (i == 20) return vec2(1, -2);
	}
	if (r == 5) {
		if (i == 0) return vec2(-4, 0);
		if (i == 1) return vec2(-3, 0);
		if (i == 2) return vec2(-2, 0);
		if (i == 3) return vec2(-1, 0);
		if (i == 4) return vec2(0, 0);
		if (i == 5) return vec2(1, 0);
		if (i == 6) return vec2(2, 0);
		if (i == 7) return vec2(3, 0);
		if (i == 8) return vec2(4, 0);
		if (i == 9) return vec2(-4, 1);
		if (i == 10) return vec2(-4, -1);
		if (i == 11) return vec2(-3, 1);
		if (i == 12) return vec2(-3, -1);
		if (i == 13) return vec2(-2, 1);
		if (i == 14) return vec2(-2, -1);
		if (i == 15) return vec2(-1, 1);
		if (i == 16) return vec2(-1, -1);
		if (i == 17) return vec2(0, 1);
		if (i == 18) return vec2(0, -1);
		if (i == 19) return vec2(1, 1);
		if (i == 20) return vec2(1, -1);
		if (i == 21) return vec2(2, 1);
		if (i == 22) return vec2(2, -1);
		if (i == 23) return vec2(3, 1);
		if (i == 24) return vec2(3, -1);
		if (i == 25) return vec2(4, 1);
		if (i == 26) return vec2(4, -1);
		if (i == 27) return vec2(-4, 2);
		if (i == 28) return vec2(-4, -2);
		if (i == 29) return vec2(-3, 2);
		if (i == 30) return vec2(-3, -2);
		if (i == 31) return vec2(-2, 2);
		if (i == 32) return vec2(-2, -2);
		if (i == 33) return vec2(-1, 2);
		if (i == 34) return vec2(-1, -2);
		if (i == 35) return vec2(0, 2);
		if (i == 36) return vec2(0, -2);
		if (i == 37) return vec2(1, 2);
		if (i == 38) return vec2(1, -2);
		if (i == 39) return vec2(2, 2);
		if (i == 40) return vec2(2, -2);
		if (i == 41) return vec2(3, 2);
		if (i == 42) return vec2(3, -2);
		if (i == 43) return vec2(4, 2);
		if (i == 44) return vec2(4, -2);
		if (i == 45) return vec2(-3, 3);
		if (i == 46) return vec2(-3, -3);
		if (i == 47) return vec2(-2, 3);
		if (i == 48) return vec2(-2, -3);
		if (i == 49) return vec2(-1, 3);
		if (i == 50) return vec2(-1, -3);
		if (i == 51) return vec2(0, 3);
		if (i == 52) return vec2(0, -3);
		if (i == 53) return vec2(1, 3);
		if (i == 54) return vec2(1, -3);
		if (i == 55) return vec2(2, 3);
		if (i == 56) return vec2(2, -3);
		if (i == 57) return vec2(3, 3);
		if (i == 58) return vec2(3, -3);
		if (i == 59) return vec2(-2, 4);
		if (i == 60) return vec2(-2, -4);
		if (i == 61) return vec2(-1, 4);
		if (i == 62) return vec2(-1, -4);
		if (i == 63) return vec2(0, 4);
		if (i == 64) return vec2(0, -4);
		if (i == 65) return vec2(1, 4);
		if (i == 66) return vec2(1, -4);
		if (i == 67) return vec2(2, 4);
		if (i == 68) return vec2(2, -4);
	}
}

vec3 cmy() {
	vec3 c = vec3(0, 1.0, 1.0);
	vec3 m = vec3(0.9, 0, 0.45);
	vec3 y = vec3(1.0, 1.0, 0);
	
	float steps = mod(time/5.0, 3.0);
	
	vec3 a;
	
	if (steps > 2.0) {
		a = m;
	} else if (steps > 1.0) {
		a = y;
	} else {
		a = c;
	}
	
	return a;
}

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

vec4 averageForRadius(vec2 co, int radius) {
    vec4 average = vec4(0);
    
    float sampleSize = 1.0;
    int n = numPointsForRadius(radius);
    float fraction = 1.0 / float(n);
	
    for (int i = 0; i < 50; i++) {
	if (i > n) break;
        vec2 spoint = pointForRadius(radius, i) / resolution.xy;
	vec4 col = subPixel(backbuffer, co + spoint);
        average += col * fraction;	    
    }
	
    return vec4(0);
}

void main( void ) 
{
    float substrate = 0.0;
	
    //vec3 brushHSL = vec3(mod(time/10.0, 1.0), 1, 0.5);
    vec3 brushRGB = cmy();
    vec3 brushHSL = RGBToHSL(brushRGB);
	
    vec3 fillHSL = vec3(0);
    vec3 fill = brushRGB;
    fill = HSLToRGB(vec3(brushHSL.r, 1, 0.1));
		
    if(length(mouse*resolution-gl_FragCoord.xy) > 20.) {
		
    	//move uv towards center so it causes a zoom in effect
        //gl_fragcoord goes from 0,0 lower left to imagesizewidth,imagesizeheight at upper right
        //float deltax = gl_FragCoord.x-resolution.x/2.0;
        //float deltay = gl_FragCoord.y-resolution.y/2.0;
        float deltax = gl_FragCoord.x/resolution.x-mouse.x;
        float deltay = gl_FragCoord.y/resolution.y-mouse.y;
        //float angleradians = atan2(deltay,deltax) * 180.0/3.14159265;
        //float angleradians = atan(deltay,deltax) * 90.0;
        float angleradians = atan(deltay,deltax)+3.14159265;
        //now walk the vector/angle between current pixel and center of screen to get pixel to average around
        float zoomrate=0.5;
        float newx = gl_FragCoord.x + cos(angleradians)*zoomrate;
        float newy = gl_FragCoord.y + sin(angleradians)*zoomrate;
        //new point   
	
        vec2 positionPixel = vec2(newx,newy);
	vec2 position = positionPixel/resolution;
	    
        vec4 radiusA = averageForRadius(position, 3);
        vec4 radiusB = averageForRadius(position, 5);
	    
	float activator = radiusA.a;
        float inhibitor = radiusB.a;
	    
	if (activator > inhibitor) {
            substrate = 1.0;
        }
	    
	if (inhibitor == 0.0) {
	    float random = rand(gl_FragCoord.xy + time);
	    if (random > 0.997) {
		substrate = 1.0;
	    }
        }
	    
	float brightness = min((activator * 10.0) - 1.0, 1.0);

	vec4 originalFill = radiusA;
	fillHSL = RGBToHSL(vec3(originalFill.r, originalFill.g, originalFill.b));
		
	fillHSL = vec3(fillHSL.r, 1.0, max(brightness * 0.5, 0.01));
	fill = HSLToRGB(fillHSL);
    }
    
    //gl_FragColor = vec4(fill.r, fill.g, fill.b, substrate);
    gl_FragColor = vec4(fill.r, fill.g, fill.b, substrate);
}
