#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float PI = 3.14159265358979323846264;
const float hbar = 1.05457172647e-34;
const float MASS = 1.;
	
vec3 hsv(float h,float s,float v) { return mix(vec3(1.),clamp((abs(fract(h+vec3(3.,2.,1.)/3.)*6.-3.)-1.),0.,1.),s)*v; }

float wavefn(int n, int m, vec2 pos) { 
	return 2. * sin(float(n) * PI * pos.x) * sin(float(m) * PI * pos.y); 
}
float omega(int n, int m) {
	float fn = float(n);
	float fm = float(m);
	
	return .5/**hbar*/*PI*PI*(fn*fn+fm*fm)/MASS;
}
vec2 phasor(float magnitude, float omega, float time) {
	float phase = omega*time;
	return magnitude*vec2(cos(phase), sin(phase));
}
vec2 cpxmult(vec2 a, vec2 b) {
	return vec2(a.x * b.x - a.y * b.y, a.x * b.y + a.y * b.x);
}

void main( void ) {
	vec2 pos = gl_FragCoord.xy / resolution.xy;
	
	vec2 ret = phasor(wavefn(1,3,pos), omega(1,3), time/20.);
	ret += phasor(wavefn(2,1,pos), omega(2,1), time/20.);	
	
	float hue = (atan(ret.x, ret.y) / PI + 1. * 1.);
	float value = sqrt(ret.x * ret.x + ret.y * ret.y) / 5.;
	gl_FragColor = vec4(hsv(hue, 1.-value, value), 1.);
}