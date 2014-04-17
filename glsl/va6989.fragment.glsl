#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define PI 3.14159
#define TWO_PI (PI*2.0)
#define N 10.0

void main( void ) {
	vec2 v = (gl_FragCoord.xy - resolution/2.0) / min(resolution.y,resolution.x) * 16.0;

	vec2 m = (mouse* resolution - resolution/2.0)  / min(resolution.y,resolution.x) * 16.0;
	
	float col = 0.0;
	float mark = 0.0;
	
	for(float i = 0.0; i < N; i++) {
	  	float a = i * (TWO_PI/N);
		float c = cos(a) + cos(a*6.0 + mouse.y*TWO_PI)*mouse.x;
		float s = sin(a) + sin(a*6.0 + mouse.y*TWO_PI)*mouse.x;
		
		float len2 = (v.x-c)*(v.x-c) + (v.y-s)*(v.y-s);
		mark += (1.0 / (1.0 + len2*300.0));
		

		col += cos( TWO_PI*(v.x * c + v.y * s));
		
	}
	
	col /= N;

	if (length(v-m) < 0.02) {
		mark += 2.0;
	}	
	gl_FragColor = vec4(col*1.5, col*1.2 + mark,-col*3.0, 1.0);


}