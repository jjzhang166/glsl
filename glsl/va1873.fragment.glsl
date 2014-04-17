// Antialiased mandelbrot set by Kabuto (some modifications by @emackey)
// Set quality to 1 (or even 0.5)

// Click 'hide code' and use the left & right mouse buttons to pan an zoom the fractal.
// See http://glsl.heroku.com/e#1872.0 for details.

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform vec2 surfaceSize;
varying vec2 surfacePosition;

const int MAX_ITER =250;

const float ANTIALIAS = 2.5; // .5 = smoother but wider

float point(vec2 s) {
	vec4 a = vec4(s,1,0);
	vec4 c = vec4(s,1,0);
	
	for(int iter = 0; iter < MAX_ITER; iter++) {	
		// Testing every 4th iteration is enough for not getting float overflow and makes this routine much faster
		a = a.x*a*vec4(1,1,2,2)+a.y*a.yxwz*vec4(-1,1,-2,2)+c;
		a = a.x*a*vec4(1,1,2,2)+a.y*a.yxwz*vec4(-1,1,-2,2)+c;
		a = a.x*a*vec4(1,1,2,2)+a.y*a.yxwz*vec4(-1,1,-2,2)+c;
		a = a.x*a*vec4(1,1,2,2)+a.y*a.yxwz*vec4(-1,1,-2,2)+c;
		if(a.x*a.x+a.y*a.y > 16.) {
			return length(a.zw)/length(a.xy)/log(length(a.xy));
		}
	}
	return 1e10;

}
 
void main( void ) {
	float zoom = 0.007;
	
	vec2 p = surfacePosition * zoom + vec2(-.746,.115);
	
	float z = ANTIALIAS/(point(p)*zoom*surfaceSize.y/resolution.y);
	gl_FragColor = vec4(vec3(z)*vec3(0.15,0.5,1.0), 1.);
}
