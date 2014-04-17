// Antialiased mandelbrot set by Kabuto

// Set quality to 1 (or even 0.5)

// Well, this is an animated julia set, not a mandelbrot set :)

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const int MAX_ITER = 1000;

const float ANTIALIAS = 2.5; // .5 = smoother but wider

const vec4 f2 = vec4(-1,1,-1,1);
const vec4 f3 = vec4(1,1,16,16);
const vec4 f4 = vec4(-1,1,-16,16);

float point(vec2 s, vec2 c2) {
	vec4 a = vec4(s,1,0);
	vec4 c = vec4(c2,0,0);
	
	for(int iter = 0; iter < MAX_ITER; iter++) {	
		// Testing every 4th iteration is enough for not getting float overflow and makes this routine much faster
		a = a.x*a+a.y*f2*a.yxwz+c;
		a = a.x*a+a.y*f2*a.yxwz+c;
		a = a.x*a+a.y*f2*a.yxwz+c;
		a = a.x*f3*a+a.y*f4*a.yxwz+c;
		if(a.x*a.x+a.y*a.y > 16.) {
			return length(a.zw)/length(a.xy)/log(length(a.xy));
		}
	}
	return 1e10;

}
 
vec2 cc = vec2(-.746+cos(time*2.)*.001,.115+sin(time*2.)*.001);

void main( void ) {
	float zoom = .1*exp(-sin(time*.3));
	
	vec2 p = (( gl_FragCoord.xy / resolution.xy - .5))*vec2(resolution.x/resolution.y, 1.) * 2. * zoom + vec2(-.746,.115);
	
	float z = ANTIALIAS/(point(p, cc)*zoom/resolution.y);
	gl_FragColor = vec4(vec3(z)*vec3(0.15,0.5,1.0), 1.);
}
