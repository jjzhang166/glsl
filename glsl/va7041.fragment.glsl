#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define PI 3.14159
#define TWO_PI (PI*2.0)
#define N 8.9

void main( void ) {
	
	vec3 rgb = vec3(-0.04, -0.04, 0.1/N);
	vec2 v = (gl_FragCoord.xy - resolution/2.0) / min(resolution.y,resolution.x) * 32.1;

	float col = 0.0;
	
	for(float i = 0.0; i < N; i++) {
	  	float a = time*0.002+tan(time*0.002)+55.0;
		col += cos( TWO_PI*(v.x * cos(a*i) + v.y *tan(a*i)*cos(a*i)))*max(sin(a*i),-0.5);
	}
	
	col /= N;

	gl_FragColor = 0.5*vec4(col+rgb.r, (col*8.0*tan(sin(col)))+rgb.g, (col*10.0*tan(col))+rgb.b, 1.0);
}