#ifdef GL_ES
precision mediump float;
#endif

// Hypergrid by @hintz 2013-10-20

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define PI 3.14159
#define TWO_PI (PI*2.0)
#define N 6.0

void main(void) 
{
	vec2 v = (gl_FragCoord.xy - resolution *0.5) / min(resolution.y,resolution.x) * 10.0;
	float col = 0.0;
	float col2 = 0.0;
	
	for (float i = 0.0; i < N; i++) 
	{
	  	float a = 0.2*time + i * (TWO_PI/N);
		vec2 w;
		
		w.x = 2.0 + v.x*cos(a) - v.y*sin(a);
  		w.y = 1.0 + v.y*cos(a) + v.x*sin(a);
	
		col += cos(cos(time)+w.x * (sin(time*0.3)+w.y) + time);
		col2 += cos(1.4*sin(time*0.7)-w.x - (cos(time*0.2)-w.y) + 0.6*time);
	}
	
	float l = 3.0+2.0*cos(col2);
	col /= 3.0;
	col = sin(col);
	gl_FragColor = vec4(normalize(0.1+vec3(l*col*sin(time*0.83-col), l*col*cos(time*0.93),l*col*sin(col+time*1.03))), 1.0);
}