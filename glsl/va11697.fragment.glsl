#ifdef GL_ES
precision mediump float;
#endif

// Neon Rings by @hintz 2013-10-21

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define PI 3.14159265359	
#define TWO_PI (PI*2.0)
#define N 6.0

void main(void) 
{
	vec2 v = (gl_FragCoord.xy - resolution * 0.5) / min(resolution.y,resolution.x) * 20.0;
	vec3 col = vec3(0.0);

	v*=cos(time*0.125);
	v+=vec2(cos(0.132*time),sin(0.133*time))*10.0;
	
	for (float i = 0.0; i < N; i++) 
	{
	  	float a = time * 0.31 + i * (TWO_PI/N);
		float b = time * 0.41 + i * (TWO_PI/N);
		vec3 w;
		float cosa = cos(a);
		float sina = sin(a);
		float cosb = cos(b);
		float sinb = sin(b);
		
		w.x = v.x*cosa - v.y*sina;
  		w.y = v.y*cosb - v.x*sinb;
		w.z =-v.y*cosb - v.x*sinb;
	
		col += sin(2.0 * sin(w + time*0.2));
	}
	
	//col = 1.0-normalize(abs(col+vec3(0.5,1.0,0.5)));
	gl_FragColor = vec4(col, 1.0);
}