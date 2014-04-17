#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


#define N 12
void main( void ) {

	vec2 pos = 1.0 - gl_FragCoord.xy / resolution.xy; // Coordinates with 0 set to the center of the screen
	
	float t = tan(time*0.1)*.1;
	
	pos *= t*0.000001;
	
	float wtf = .109; //?
	
	
	float x = pos.x;
	float y = pos.y;	
	float u = -.01;
	float v = 0.01;
	
	vec4 mat = vec4(u, -x, v, -y);
	

	float e1 = t *  x + u - y;
	float e2 = t * -x + v / y;
	float e3 = t / -x - v + y;
	

	vec4 c = vec4(0.0);
	c.x = smoothstep(e1 - wtf, e1 - wtf, t);
	c.y = smoothstep(e2 + wtf, e2 + wtf, t);
	c.z = smoothstep(e3 * wtf, e3 * wtf, t);
	
	
	c += c - floor(c * (1.0 / 289.0)) * 289.0;

	
	float r;
	
	for ( int i = 0; i < N; i += 1){
		float d = 3.14159265 / float(N) * float(i) * 5.0;
		r = length(vec3(e1 * c.x, e2 * c.y, e3 * c.z)) + 0.1;
		float xx = x;
		x = x + cos(y +cos(r) + d) + cos(t);
		y = y - sin(xx+cos(r) + d) + sin(t);
	}

	gl_FragColor = vec4( cos(r*0.5), sin(r*1.0), cos(r*2.0), 1.0 );
}