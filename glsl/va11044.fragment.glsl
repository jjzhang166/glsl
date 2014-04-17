#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//first one from scratch unaided

const vec3 e = vec3(.0001, 0., 0.);

struct view{
	vec3 p;
	vec3 d;
};

struct ray{
	vec3 p;
	vec3 d;
	vec3 n;
	vec3 c;
	float l;
};

struct light{
	vec3 p;
	vec3 d;
	vec3 c;
};
	
struct mat{
	vec3 c;
	float s;
	vec3 sc;
};
	
ray trace(ray r);
float map(vec3 p);
vec3 derivate(vec3 p);
ray shade(ray r, light l, mat m);

float sphere(vec3 p, float r);

void main() {
	vec2 uv = .5 - gl_FragCoord.xy/resolution.xy;
	float a = resolution.x/resolution.y;
	vec3 wp = vec3(a * uv, -1.2-length(.05*uv));

	view v;
	v.p = vec3(0.);
	v.d = normalize(wp);

	light l;
	float lt = time;
	l.p = vec3(cos(wp.x+lt)*16., -5., sin(wp.y+lt)*16.-2.);
	l.c = vec3(.7,.7, .5);
	
	mat m;
	m.c = vec3(.5, .5, .5);
	m.s = 64.;
	m.sc = vec3(.6, .6, .3);
	
	ray r;
	r.p = v.p;
	r.d = v.d;
	r.n = r.d;
		r.l = 0.;

	r = trace(r);

	if(r.l < 32.){
		r = shade(r, l, m);
	}else{
		r.c = l.c*r.d.y;
	}
	
	gl_FragColor = vec4(r.c, 0.);
}

ray trace(ray r){
	float l;
	for(int i = 0; i < 64; i++){
	l = map(r.p);
	r.p += l*r.d;
	r.l += l;
	if(l<0.01) {break;}
	if(r.l>32.){break;}
	}
	return r;
}

float map(vec3 p){
	vec3 ps = vec3((.5-mouse)*5., -5.5);
	
	p = p - ps;

	return sphere(p, 1.);
}

vec3 derivate(vec3 p){
	vec3 d = vec3(
		map(p+e.xyy)-map(p-e.xyy),
		map(p+e.yxy)-map(p-e.yxy),
		map(p+e.yyx)-map(p-e.yyx)
	);
	return normalize(d);
}

ray shade(ray r, light l, mat m){
	r.n = derivate(r.p);
	l.d = normalize(l.p - r.p);
	
	float ndl = max(0., dot(r.n, l.d));
	
	vec3 h = normalize(l.d-r.d);
	float ndh = max(0., dot(r.n, h));
	vec3 s = pow(ndh, m.s) * l.c;
	vec3 f = clamp(cos(dot(r.d, r.n)), 0., .5) * l.c;
	
	r.c = m.c * ndl + s + f * ndl;
	
	r.c = pow(r.c, vec3(2.2));
	
	return r;
}

float sphere(vec3 p, float r){
	return length(p)-r;
}
