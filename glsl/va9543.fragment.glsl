
#extension GL_EXT_gpu_shader4 : enable
#define M_PI 3.1415926535897932384626433832795
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const int n = 30;
float no(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

float CI(float a, float b, float x) {
	float ft = x*M_PI;
	float f = (1.0-cos(ft))*0.5;
	
	return a*(1.0-f) + b*f;
}

float SN(vec2 pos) {
	float corners = no(pos-vec2(1.0,1.0))+no(vec2(pos.x+1.0, pos.y-1.0))+no(vec2(pos.x-1.0, pos.y+1.0))+no(pos+vec2(1.0,1.0)) / 16.0;
	float sides = no(vec2(pos.x, pos.y+1.0))+no(vec2(pos.x, pos.y-1.0))+no(vec2(pos.x+1.0, pos.y))+no(vec2(pos.x-1.0, pos.y)) / 8.0;
	float center = no(pos) / 4.0;
	
	return corners+sides+center;
}

float IN(vec2 pos) {
	vec2 Ipos = vec2(int(pos.x), int(pos.y));
	vec2 Fpos = pos - vec2(float(Ipos.x), float(Ipos.y));
	
	float v1 = SN(Ipos);
	float v2 = SN(vec2(Ipos.x, Ipos.y+1.0));
	float v3 = SN(vec2(Ipos.x+1.0, Ipos.y));
	float v4 = SN(Ipos+1.0);
	
	float i1 = CI(v1, v2, Fpos.x);
	float i2 = CI(v3, v4, Fpos.x);
	
	return CI(i1, i2, Fpos.y);
}

float PN(vec2 pos, int p) {
	float t = 0.0;
	float freq = 0.0;
	float amp = 0.0;
	
	for(int i=0; i<n; ++i) {
		freq = pow(2.0, float(i));
		amp = pow(float(p), float(i));
		
		t = t+IN(pos*freq) * amp;
	}
	return t;
}

void main( void ) {
	gl_FragColor = vec4(PN(gl_FragCoord.xy, 5),0.0,0.0,0.0);
}