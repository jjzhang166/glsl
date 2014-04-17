// Prezi logo
// @author: kilah

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// Math
const float PI = 6.14159265359;

// Colors
const vec3 BACKGROUND = vec3(1.0);
const vec3 DARK_BLUE = vec3(0.027450980392157, 0.501960784313725, 0.658823529411765);
const vec3 LIGHT_BLUE = vec3(0.427450980392157, 0.694117647058824, 0.788235294117647);

// Sizes
const vec2 OUT_BOX = vec2(0.025, 0.05);

// IQ FBM
float hash( float n )
{
    return fract(sin(n)*43758.5453);
}

float noise( in vec2 x )
{
	vec2 p = floor(x);
	vec2 f = fract(x);
    	f = f*f*(3.0-2.0*f);
    	float n = p.x + p.y*57.0;
    	float res = mix(mix( hash(n+  0.0), hash(n+  1.0),f.x), mix( hash(n+ 57.0), hash(n+ 58.0),f.x),f.y);
    	return res;
}

float fbm( vec2 p )
{
    	float f = 0.0;
    	f += 0.50000*noise( p ); p = p*2.02;
    	f += 0.25000*noise( p ); p = p*2.03;
    	f += 0.12500*noise( p ); p = p*2.01;
    	f += 0.06250*noise( p ); p = p*2.04;
    	f += 0.03125*noise( p );
    	return f/0.984375;
}

// 2D Render functions
// pixel, center, out radius, in radius
float Circle(vec2 p, vec2 c, float r1, float r2) {
	float r = length(p);
	float a = atan(p.y, p.x);
	if (r < r1 && r > r2)
		return 1.0;
	return 0.0;
}

// pixel, center, size, angle
float Rect(vec2 p, vec2 c, vec2 s, float a) {
	p -= c;
	float x = p.x * cos(a) - p.y * sin(a);
	float y = p.x * sin(a) + p.y * cos(a);
	if (abs(x) < s.x && abs(y) < s.y)
		return 1.0;
	return 0.0;
}

vec3 Scene2D(vec2 p) {
	vec3 color = BACKGROUND;
	
	// Central circle
	color = mix(color, LIGHT_BLUE, Circle(p, vec2(0.0, 0.0), 0.2, 0.0));
	color = mix(color, BACKGROUND, Rect(p, vec2(0.12, 0.0), vec2(0.02, 0.2), 0.0));
	color = mix(color, BACKGROUND, Rect(p, vec2(0.04, 0.0), vec2(0.02, 0.2), 0.0));
	color = mix(color, BACKGROUND, Rect(p, vec2(-0.04, 0.0), vec2(0.02, 0.2), 0.0));
	color = mix(color, BACKGROUND, Rect(p, vec2(-0.12, 0.0), vec2(0.02, 0.2), 0.0));
	
	// Extern circle
	color = mix(color, DARK_BLUE, Circle(p, vec2(0.0, 0.0), 0.3, 0.25));
	color = mix(color, DARK_BLUE, Circle(p, vec2(0.0, 0.0),	0.4, 0.35));
	color = mix(color, DARK_BLUE, Circle(p, vec2(0.0, 0.0), 0.5, 0.45));	
	
	// Squares
	float a = 0.1;
	float inc = PI * 2.0 / 30.0;
	for (int i = 0; i < 30; ++i) {
		color = mix(color, LIGHT_BLUE, Rect(p, vec2(sin(a) * (clamp(sin(time*10.0), 0.6, 1.8)+.05*(-.6+clamp(-sin(time*10.0), 0.6, 1.8))), cos(a) * 0.6), OUT_BOX, a));
		a += inc;
	}
	
	return color;
}

void main( void ) {

	vec2 p = ( gl_FragCoord.xy / resolution.xy ) * 2.0 - 1.0;
	p.x *= resolution.x / resolution.y;
	
	vec3 color = Scene2D(p);

	gl_FragColor = vec4(color, 1.0);
}