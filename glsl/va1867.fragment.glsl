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

const float ANTIALIAS = 2.0; // .5 = smoother but wider

float point(vec2 s) {
	vec4 a = vec4(s,1,0);
	vec4 c = vec4(s,1,0) * (vec4(mouse, mouse) + 0.5);
	
	for(int iter = 0; iter < MAX_ITER; iter++) {	
		// Testing every 4th iteration is enough for not getting float overflow and makes this routine much faster
		a = a.x*a*vec4(1. * abs(sin(time * 5.0)),1. * sin(time * 5.0),2. * abs(sin(time * 5.0)),2)+a.y*a.yxwz*vec4(-1,1,-2,2)+c;
		a = a.x*a*vec4(1. * abs(sin(time * 5.0)),1. * sin(time * 5.0),2. * abs(sin(time * 5.0)),2)+a.y*a.yxwz*vec4(-1,1,-2,2)+c;
		a = a.x*a*vec4(1. * abs(sin(time * 5.0)),1. * sin(time * 5.0),2. * abs(sin(time * 5.0)),2)+a.y*a.yxwz*vec4(-1,1,-2,2)+c;
		a = a.x*a*vec4(1. * abs(sin(time * 5.0)),1. * sin(time * 5.0),2. * abs(sin(time * 5.0)),2)+a.y*a.yxwz*vec4(-1,1,-2,2)+c;
		if(a.x*a.x+a.y*a.y > 16.) {
			return length(a.zw)/length(a.xy)/log(length(a.xy));
		}
	}
	return 1e10;

}
 
void main( void ) {
	float zoom = 1.0;
	
	vec2 p = (( gl_FragCoord.xy / resolution.xy - .84912))*vec2(resolution.x/resolution.y, 1.) * 2. * zoom + vec2(-.7476,.115);
	
	float z = ANTIALIAS/(point(p)*zoom/resolution.y);
	gl_FragColor = vec4(vec3(z)*vec3(0.15,0.5,1.0), 1.);
}
