#ifdef GL_ES
precision mediump float;
#endif
#define PROCESSING_COLOR_SHADER
uniform float time;                                                     
uniform vec2 mouse;
uniform vec2 resolution;


#define PI 3.14159
#define TWO_PI (PI*2.0)
#define N 8.0

void main(void) 
{

	vec2 v = (gl_FragCoord.xy / resolution.xy * 8.0 - 1.0);	
	float col = 0.0;                                                                                          
	for(float i = 0.0; i < N; i++) {
	  	float a = i * (TWO_PI/N) ;
		col += tan((v.y * cos(a) + v.x * sin(a) +abs(sin(time*a*0.1))*10.0  ));
	}
	gl_FragColor = vec4(col/3.0,col/12.0,col/2.0, 1.0);
}
