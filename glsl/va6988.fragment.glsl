#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define PI 3.14159
#define TWO_PI (PI*2.0)
#define N 60.0

void main( void ) {
	vec2 v = (gl_FragCoord.xy - resolution/2.0) / min(resolution.y,resolution.x) * 10.0;

	float col = 0.0;
	
	for(float i = 0.0; i < N; i++) {
	  	float a = i * (TWO_PI/N);
		col += cos( TWO_PI*(v.x * cos(a) + v.y * sin(a)+ i*mouse.x));
	}
	
	col /= N;

	gl_FragColor = vec4(col*15.0*sin(mouse.x), col*5.1*tan(gl_FragCoord.y),-col*3.0*sin(mouse.y), 1.0);


}