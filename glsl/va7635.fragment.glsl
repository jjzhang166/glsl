#ifdef GL_ES
precision mediump float;
#endif

// modified by @hintz

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define PI 3.14159
#define TWO_PI (PI*2.0)
#define N 12.0

float triangle_wave(float f){ return abs(fract(f)-0.5)*4.0-1.0; }

void main(void) 
{
	vec2 v = (gl_FragCoord.xy - resolution/2.0) / min(resolution.y,resolution.x) * 5.0;

	float col = 0.1;

	for(float i = 0.0; i < N; i++) 
	{
	  	float a = i * (TWO_PI/N);
		float c = cos(a);
		float s = sin(a);
		float p = v.y * c + v.x * s + 0.0001;
		
		col += triangle_wave((p -time*0.5*sign(p)));
	}

	gl_FragColor = vec4(sign(col-0.6*N), sign(col-0.5*N), sign(col-0.3*N), 1.0);
}