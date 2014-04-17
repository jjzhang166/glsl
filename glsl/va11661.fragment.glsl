#ifdef GL_ES
precision mediump float;
#endif

// Neon Rings by @hintz 2013-10-21

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define PI 3.14159265359	
#define TWO_PI (PI*2.0)
#define N 3.0

void main(void) 
{
	vec2 v = (gl_FragCoord.xy - resolution * 0.5) / min(resolution.y,resolution.x) * 40.0;
	vec3 col = vec3(0.0);
	
	//v*=cos(time*0.250)*10.;
	//v+=5.0*vec2(cos(0.3*time),sin(0.3*time))*10.;
	for (float i = 0.0; i < N; i++) 
	{
	  	float a =  i * (TWO_PI/N);
		vec3 w;
		float cosa = cos(a);
		float sina = sin(a);
		
		w.x = v.x*cosa - v.y*sina;
  		w.y = v.y*cosa + v.x*sina;
		w.z = -(v.y*cosa + v.x*sina);
	
		col.rgb += sin(w + time*0.9);
	}
	
	//col = 1.0-normalize(abs(col+vec3(0.5,1.0,0.5)));
	gl_FragColor = vec4(col, 1.0);
}