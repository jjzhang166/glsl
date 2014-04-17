#ifdef GL_ES
precision mediump float;
#endif

// Rings by @hintz 2013-10-21

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define PI 3.14159
#define TWO_PI (PI*2.0)
#define N 6.0

void main(void) 
{
	vec2 v = (gl_FragCoord.xy - resolution * 0.5) / min(resolution.y,resolution.x) * 40.0;
	vec3 col = vec3(0.0);
	
	v*=cos(time*0.5);
	v+=5.0*vec2(cos(0.3*time),sin(0.3*time));
	
	for (float i = 0.0; i < N; i++) 
	{
	  	float a = 0.2*time + i * (TWO_PI/N);
		vec2 w;
		float cosa = cos(a);
		float sina = sin(a);
		
		w.x = v.x*cosa - v.y*sina;
  		w.y = v.y*cosa + v.x*sina;
	
		col += vec3(cos(w.y + time),sin(w.y + time*0.9),cos(w.x + time*0.8));
	}
	
	col = 1.0-abs(col);
	gl_FragColor = vec4(col, 1.0);
}