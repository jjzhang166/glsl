#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define PI 3.14159
#define TWO_PI (PI*2.0)
#define N 30.0

void main( void ) {
	vec2 v = (gl_FragCoord.xy - resolution/2.0) / min(resolution.y,resolution.x) * 5.0;
        v =  (mat3(1.-.05 * sin(time) * .1,.2 * sin(time),0.5,1.,0.3,.1,.2,.4,0.2) * vec3(v,.0)).xy;
	float col = 0.0;
	
	for(float i = 0.0; i < N; i++) {
	  	float a = time*0.002+tan(time*0.002)+50.0;
		col += cos( TWO_PI*(v.x * cos(a*i) + v.y *tan(a*i)*cos(a*i)))*max(sin(i),-0.5);
	}
	
	//col /= N;

	gl_FragColor = vec4(col);//, col*8.0*tan(sin(col)), col*10.0*tan(col), 1.0);
}