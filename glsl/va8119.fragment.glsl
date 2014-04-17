#ifdef GL_ES
precision mediump float;
#endif

uniform float time;                                                     
uniform vec2 mouse;
uniform vec2 resolution;

#define PI 3.14159
#define TWO_PI (PI*2.0)
#define N 50.0

void main(void) 
{

	vec2 v = gl_FragCoord.xy / resolution.x * 200000000000.0-100000000000.0;	
	float col = 0.0;                                                                                          
	float col2 = 0.0;   
	
	for(float i = 0.0; i < N; i++) 
	{
	  	float a = i * (TWO_PI/N) ;
		col += sin((v.y * cos(a) + v.x * sin(a) + (sin(time*a*0.1))*10.0));
		col2 += cos((v.y * sin(a) + v.x * cos(a) + (cos(time*a*0.11))*10.0));
	}
	gl_FragColor = vec4(col/5.0, (col+col2)/12.0, col2*0.1, 1.0);
}
