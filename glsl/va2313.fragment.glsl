// Antialiased mandelbrot set by Kabuto

// Set quality to 1 (or even 0.5)

// See 1603.4 for a version that renders julia sets instead

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const int MAX_ITER =50;

const float ANTIALIAS = 1.0; // .5 = smoother but wider

float point(vec2 s) {
	vec4 a = vec4(s,1.0,0.0);
	vec4 c = vec4(s,1.0,0.0);
	
	for(int iter = 0; iter < MAX_ITER; iter++) {	
		// Testing every 4th iteration is enough for not getting float overflow and makes this routine much faster
		a = a.x*a*vec4(1.0,1.0,2.0,2.0)+a.y*a.yxwz*vec4(-1.0,1.0,-2.0,2.0)+c;
		if(a.x*a.x+a.y*a.y > 16.0) {
			return length(a.zw)/length(a.xy)/log(length(a.xy));
		}
	}
	return 1e10;

}
 
void main( void ) {
	float zoom = 0.0015*exp(-sin(time*0.3)*2.0-1.1);
	
	vec2 p = (( gl_FragCoord.xy / resolution.xy - 0.5))*vec2(resolution.x/resolution.y, 1.0) * 2.0 * zoom + vec2(-0.746,0.115);
	
	float z = ANTIALIAS/(point(p)*zoom/resolution.y);
	gl_FragColor = vec4(vec3(z)*vec3(0.15,0.5,1.0), 1.0);
}
