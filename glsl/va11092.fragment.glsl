#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const vec3 e = vec3(.00001, 0., 0.);
const int s = 32;

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
	float sp;
	float sm;
	float ri;
	vec3  dc;
	vec3  sc;
};
	
ray trace(ray r);
float map(vec3 p);
vec3 derivate(vec3 p);

ray shade(ray r, view v, light l, mat m);
float diffuse(const in ray r, const in light l);
float schlick( const in ray r, const in view v, const in mat m);
float blinnphong(const in ray r, const in light l, const in mat m);
float ao(const in ray r);

float sphere(vec3 p, float r);

void main() {
	vec2 uv = .5 - gl_FragCoord.xy/resolution.xy;
	float a = resolution.x/resolution.y;
	float va = 1.+length(.05*uv);
	vec3 wp = vec3(a * uv, -1.*va);

	view v;
	v.p = vec3(0.);
	v.d = normalize(wp);

	light l;
	float lt = time;
	l.p = vec3(cos(wp.x+lt)*16., -5., sin(wp.y+lt)*16.-2.);
	l.c = vec3(.5,.5,.5);
	float g = length(.2*l.p-wp) * .8;
	
	mat m;
	m.sp = 128.;
	m.sm = .8;
	m.ri = .25;
	m.dc = vec3(.5, .5, .5);
	m.sc = vec3(.5, .5, .5);;
	
	
	ray r;
	r.p = v.p;
	r.d = v.d;
	
	r = trace(r);

	if(r.l < 32.){
		r = shade(r, v, l, m);
	}
	
	gl_FragColor = vec4(r.c, 0.);
}

ray trace(ray r){
	float l;
	for(int i = 0; i < s; i++){
		l = map(r.p);
		r.p += l*r.d;
		r.l += l;
		if(l-.001 < 0.0) {break;}
		if(r.l>float(s))  {break;}
	}
	return r;
}

float map(vec3 p){
	float r;
	
	vec3 ps = vec3((.5-mouse)*5., -5.);	
	float s = sphere(p - ps, 1.);
	
	r = s;
	
	return r;
}

vec3 derivate(vec3 p){
	vec3 d = vec3(
	map(p+e.xyy)-map(p-e.xyy),
	map(p+e.yxy)-map(p-e.yxy),
	map(p+e.yyx)-map(p-e.yyx)
	);
	return normalize(d);
}

ray shade(ray r, view v, light l, mat m){
	r.n = derivate(r.p);
	l.d = normalize(l.p - r.p);
	
	float d = diffuse(r, l);
	float f = schlick(r, v, m);
	float s = blinnphong(r, l, m);
	
	r.c = m.dc + d * l.c + f * s * m.sc;
	
	//r.c = pow(r.c, vec3(2.2));
	
	return r;
}


float schlick(const in ray r, const in view v, const in mat m)
{
	float f = dot(r.n, -v.d);
	f = min(max((1. - f), 0.0), 1.0);
	float f2 = f * f;
	float f5 = f2 * f2 * f;
	return m.ri + (1. - m.ri) * f5 * m.sm;
}


float diffuse(const in ray r, const in light l)
{
	return max(0.0, dot(l.d, r.n));
}


float blinnphong(const in ray r, const in light l, const in mat m)
{           
	vec3 h = normalize(l.d - r.d);
	float ndh = max(0.0, dot(h, r.n));

	float sp = exp2(4.0 + 6.0 * m.sm);
	float si = (m.sp + 2.0) * 0.125;

	return pow(ndh, sp) * si;
}

// use distance field to evaluate ambient occlusion
float ao(const in ray r)
{
	float o = 1.0;
	float l = 0.0;
	for(int i=0; i<=5; i++)
	{
		l += 0.1;

		float ml = map(r.p + r.n * l);

		o *= 1.0 - max(0.0, (l - ml) * 0.2 / l );                                   
	}
       
	return o;
}


vec3 obj0_c(in vec3 p){
 if (fract(p.x*.5)>.5)
   if (fract(p.z*.5)>.5)
     return vec3(0,0,0);
   else
     return vec3(1,1,1);
 else
   if (fract(p.z*.5)>.5)
     return vec3(1,1,1);
   else
     	return vec3(0,0,0);
}

float sphere(vec3 p, float r){
	return length(p)-r;
}
