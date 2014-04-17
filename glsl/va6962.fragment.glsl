
#ifdef GL_ES
precision mediump float;
#endif

uniform float time; // TODO!

varying vec2 surfacePosition;

const int MAX_ITERATIONS = 60;
const vec2 SCALE = vec2(2, 2);
const vec2 OFFSET = vec2(-0.7, 0.0);

vec3 hsv(float h,float s,float v) { return mix(vec3(1.),clamp((abs(fract(h+vec3(3.,2.,1.)/3.)*6.-3.)-1.),0.,1.),s)*v; }

vec3 colorMap(float v) {2
	return hsv(mod(v + time/10.0, 1.0), sin(v + time/3.0)/3. + 0.6, 1.0);
}
}