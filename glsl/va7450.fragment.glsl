#ifdef GL_ES
precision mediump float;
#endif

// modified by @hintz

// named some values _knaut 

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

uniform float nSides;
uniform float scopeRes;
uniform float speed;

uniform float r;
uniform float g;
uniform float b;

uniform float brightness;
uniform float kaleidoRotate;

#define PI 3.14159
#define TWO_PI (PI*2.0)
#define N 6.

void main(void) 
{
	// set some arbitrary values
	float nSides = 6.00;
	float scopeRes = 15.;	// our pattern resolution
	float speed = 0.002;
	
	// set arbitrary color values
	float r = 0.1;
	float g = 0.5;
	float b = 0.5;
	float brightness = .95;
	
	float kaleidoRotate = 1.9;
	
	vec2 center = (gl_FragCoord.xy);
	center.x=-100.10*sin(time/200.0);
	center.y=-100.12*cos(time/200.0);
	
	vec2 v = (gl_FragCoord.xy - resolution/20.) / min(resolution.y,resolution.x) * scopeRes;
	v.x=v.x-10.;
	v.y=v.y-200.0;
	float col = 0.0;

	for(float i = 0.0; i < N; i++) 
	{
	  	float a = i * (TWO_PI/nSides) * (169.0 + kaleidoRotate);
		col += cos(TWO_PI*(v.y * cos(a) + v.x * sin(a) + mouse.x + i * mouse.y + sin(time*speed)* 165.0 ));
	}
	
	col *= brightness;

	gl_FragColor = vec4(col * r, col * g, col * b, 1.0);
}