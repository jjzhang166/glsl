#ifdef GL_ES
precision mediump float;
#endif

// Hypergrid by @hintz 2013-10-20

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define PI 3.14159
#define TWO_PI (PI*2.0)
#define N 8.0

void main(void) 
{
	vec2 v = (gl_FragCoord.xy - resolution *0.5) / min(resolution.y,resolution.x) * 15.0;
	float col = 0.0;

	for (float i = 0.0; i < N; i++) 
	{
	  	float a = 0.2*time + i * (TWO_PI/N);
		vec2 w;
		
		w.x = 2.0 + v.x*cos(a) - v.y*sin(a);
  		w.y = 1.0 + v.y*cos(a) + v.x*sin(a);
	
		col += cos(cos(time)+w.x * (sin(time)+w.y) + time);
	}
	
	col /= 3.0;
	float l = 1.5*abs(col);
	gl_FragColor = vec4(step(length(vec4(l+col*sin(time*0.83), l-col*cos(time*0.9),l+col*sin(time*1.23), 0.5)),0.6));
}