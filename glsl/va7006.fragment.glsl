
#ifdef GL_ES
precision mediump float;
#endif

uniform float time; // TODO!

varying vec2 surfacePosition;

const int MAX_ITERATIONS = 150;
const vec2 SCALE = vec2(2.5, 2.5);
const vec2 OFFSET = vec2(-0.7, 0.1);

vec3 hsv(float h,float s,float v) { return mix(vec3(1.),clamp((abs(fract(h+vec3(3.,1.,2.)/3.)*6.-3.)-1.),0.,1.),s)*v; }

vec3 colorMap(float v) {
	return hsv(mod(v + time/11.0, 1.0), sin(v + time/3.0)/3. + 0.6, 1.0);
}

vec3 mandelbrot(vec2 c) {
	vec2 r = c;
	for (int i = 0; i < MAX_ITERATIONS; ++i) {
		if (dot(r, r) > 4.0) {
			return colorMap(pow(float(i)/float(MAX_ITERATIONS), 0.8));
		}
		float bnd = 1. + 1. * sin(float(i) * .000001 + time * .5 + length(surfacePosition) * 1.);
		r = c + vec2(r.x*r.x - r.y*r.y, bnd*r.x*r.y);
	}
	return vec3(0.0);
}

void main(void) {	
	vec2 position = surfacePosition * SCALE + OFFSET;
	gl_FragColor = vec4(mandelbrot(position), 1.0);
}