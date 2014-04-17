#ifdef GL_ES
precision mediump float;
#endif

// modified by @hintz

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

uniform float acceleration;
uniform float xInterference;

uniform float rC;
uniform float gC;
uniform float bC;

uniform float nOffset;
uniform float nRes;

// naming & playing, knaut knowing what he does ...

#define PI 2.9
#define TWO_PI (PI*1.22)
#define N 8.0

void main(void) 
{
	// define some control vars
	
	float acceleration = 0.105;
	float xInterference = sin(16.5);
	float yInterference = cos(16.5);
	
	float rC = 0.5;
	float gC = 0.2;
	float bC = 2.5;
	
	float nOffset = 20.0;
	float nRes = 15.0;
	
	vec2 center = (gl_FragCoord.xy);
	center.x=-3.12*sin(time/150.0);
	center.y=-10.12*cos(time/200.0);
	
	vec2 v = (gl_FragCoord.xy - resolution/20.0) / min(resolution.y,resolution.x) * nRes;
	v.x=v.x-200.0;
	v.y=v.y-200.0;
	float col = 0.0;

	for(float i = 0.0; i < N; i++) 
	{
	  	float a = i * (TWO_PI/N) * 20.0;
		col += cos(TWO_PI*(v.y * cos(a) + v.x * sin(a) + -i*yInterference +i*xInterference + sin(time*acceleration)*10.0 ));
	}
	
	col /= 1.0;

	gl_FragColor = vec4(col*rC, -col*gC,-col*-bC, 1.0);
}