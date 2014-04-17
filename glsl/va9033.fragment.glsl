// Backwards mandelbrot: sqrt(Zn-c) = Zn+1
// WARNING: Incredibly boring

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
varying vec2 surfacePosition;

vec2 sumCplx(vec2 a, vec2 b) {
	return vec2(a.x+b.x, a.y+b.y);
}

vec2 quadCplx(vec2 a) {
	return vec2(a.x*a.x - a.y*a.y , 2.0*a.x*a.y);
}

vec2 sqrtCplx(vec2 a) {
	return vec2(sqrt((dot(a,a)+a.x)/2.),sign(a.y)*sqrt((dot(a,a)-a.x)/2.));
}

#define step 32
#define Kc   0.05

void main( void ) {

	float iter = 0.0;
	
	vec2 c = surfacePosition;
	
	vec2 z = vec2(sin(time), cos(time));
	gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0 );
	for(int i=0; i < step; i++) {
		
		iter += 1.00;
		
		z = sqrtCplx(z - c);
		
		if (length(z) > 2.0) {
			gl_FragColor = vec4((iter * Kc)*2.0, (iter * Kc)*0.5, 1.0-(iter * Kc)*1.5,  1.0 );
			return;
		}
	}
}