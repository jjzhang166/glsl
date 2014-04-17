#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
//varying vec2 surfacePosition;

#define ITERS_MAX 100

struct StepData {
	vec3 p;
	float d;
	vec3 n;
	vec3 color;
	int iters;
};

//negative distances are inside objects

void sphereInf(float radius, inout StepData s) {
	vec3 delta = mod(s.p,1.0)-vec3(0.5);
	s.d = length(delta) - radius;
	s.n = normalize(delta);
	if (s.d <= 0.000001)
		s.color.b += 0.001;
}
void scene(inout StepData s) {
	sphereInf(0.1,s);
}
void rayMarcher(vec3 ray, inout StepData s) {
	for (int i=0; i<ITERS_MAX; i++) {
		s.iters = i;
		scene(s);
		if (s.d <= 0.0000001) {
			ray += s.n*0.1;
			s.p += ray;
			//break;
		} else 
			s.p += ray*s.d;
	}
}
void lighting(inout StepData s) {
	s.color.r = float(s.iters)/float(ITERS_MAX);
	s.color.g = s.d;
}
void main( void ) {
	vec2 pixel = gl_FragCoord.xy/resolution.xy - 0.5;
	pixel.x *= resolution.x/resolution.y;
	//vec2 pixel2 = surfacePosition; //[-1,1]
	//float zoom = pow(2.0,pixel.x / pixel2.x);
	//x+ right, y+ up, z+ towards viewer/backward
	vec3 o = vec3(0,0,0) + vec3((mouse-0.5)*2.0,0); 
	vec3 ray = vec3(pixel.x,pixel.y,-1.0);
	StepData s;
	s.p = o;
	rayMarcher(normalize(ray),s);
	lighting(s);
	gl_FragColor.xyz = s.color;
}
