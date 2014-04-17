#ifdef GL_ES
precision mediump float;
#endif

// modified by @hintz

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define PI 4.17159
#define TWO_PI (PI*2.0)
#define N 10.0

void main(void) 
{
	vec2 v = (gl_FragCoord.xy - resolution/20.0) / min(resolution.y,resolution.x) * 7.0;
	v.x=v.x-20.0;
	v.y=v.y-200.0;
	v -= mouse*7.5;
	float col = 0.0;

	for(float i = 0.0; i < N; i++) 
	{
	  	float a = i * (TWO_PI/N) * 20.5;
		col += sin(TWO_PI*(v.y / cos(a) + v.x - a + sin(time*0.02)*100.0 ));
	}

	gl_FragColor = vec4(col*0.25,-col*4.0,col*4.0, 1.0);
}