#ifdef GL_ES
precision highp float;
#endif

//adapting http://glsl.heroku.com/e#10856.0 as an exercise

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform vec2 surfaceSize;
varying vec2 surfacePosition;

#define hpi   1.5707963
#define pi    3.1415926
#define tau   6.2831853
#define phi   .00001
#define delta .0001

const int maxi = 128;
const int maxs = 64;
const int maxao = 8;

struct view{
	vec3 p;
	vec3 d;
};

struct ray{
	vec3  p;
	vec3  d;
	vec3  n;
	vec3  c;
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
ray project(ray r);
	
ray shade(ray r, view v, light l, mat m);
float diffuse(const in ray r, const in light l);
float schlick(const in ray r, const in view v, const in mat m);
float blinnphong(const in ray r, const in light l, const in mat m);
float shadow(const in ray r, const in light l, const in float lm);
float ao(const in ray r);
vec3 gi(vec4 n);
	
float sphere(const in vec3 p, const in float r);
float cuboid(const in vec3 p, const in vec3 s);

void main() {
	vec2 uv = gl_FragCoord.xy/resolution.xy;
	vec2 o = (((2.*gl_FragCoord.xy - resolution.xy*.5)/ resolution.xy*.5)) * surfaceSize + surfacePosition;
	
	view v;
	v.p = vec3(o - surfaceSize * .25, 0.) ;
	v.d = normalize(vec3(v.p.xy, -1.));

	light l;
	float lt = time;
	l.p = vec3(cos(o.x+lt)*16., 5., sin(o.x+lt)*16.-2.);
	l.c = vec3(.75,.75,.85);
	
	mat m;
	m.sp = 128.;
	m.sm = .95;
	m.ri = .03;
	m.dc = vec3(.3, .3, .3);
	m.sc = vec3(.2, .2, .2);;
	
	ray r;
	r.p = v.p;
	r.d = v.d;
	
	r = trace(r);

	if(r.l < float(maxi)){
		r = shade(r, v, l, m);
		vec3 c = r.c;
		r.l = 0.;
		r.p = r.p+r.n*.01;
		r.d = r.n;
		v.p = r.p;
		v.d = r.d;
		r = trace(r);
		r = shade(r, v, l, m);
		c += r.c*.05;
		r.c = c;
	}
	
	gl_FragColor = vec4(r.c, 0.);
}

ray trace(ray r){
	float l;
	for(int i = 0; i < maxi; i++){
		l = map(r.p);
		r.p += l*r.d;
		r.l += l;
		if(l-phi < 0.)   {break;}
		if(r.l>float(maxi)) {break;}
	}
	return r;
}

float map(vec3 p){
	float r;
	
	vec3 ps = vec3(0., 0., -1.);	
	float s = sphere(p - ps, 1.);
	
	vec3 cs = vec3(0., -1., -1.);	
	float c = cuboid(p - cs, vec3(1.4, .1, 1.4));
	
	r = min(s, c);
	
	return r;
}

vec3 derivate4( const in vec3 p )
{
	float d = delta;

	vec3 d0 = vec3( d, -d, -d);
	vec3 d1 = vec3(-d, -d,  d);
	vec3 d2 = vec3(-d,  d, -d);
	vec3 d3 = vec3( d,  d,  d);

	float f0 = map(p + d0);
	float f1 = map(p + d1);
	float f2 = map(p + d2);
	float f3 = map(p + d3);

	return normalize(d0 * f0 + d1 * f1 + d2 * f2 + d3 * f3);
}

vec3 derivate3(vec3 p){
	vec3 e = vec3(delta, 0., 0.);
	vec3 d = vec3(
	map(p+e.xyy)-map(p-e.xyy),
	map(p+e.yxy)-map(p-e.yxy),
	map(p+e.yyx)-map(p-e.yyx)
	);
	return normalize(d);
}

ray shade(ray r, view v, light l, mat m){
	vec3 lr = l.p-r.p;
	float lm = length(lr);
	float attn = 1. / lm*lm;
	l.d = normalize(lr);
	
	r.n = derivate4(r.p);
	
	float o  = ao(r) * attn;
	vec3  i  = gi(vec4(r.n,1.)) * o;
	float sh = shadow(r, l, attn);
	float d = diffuse(r, l) * sh * o;
	float f = schlick(r, v, m) * o;
	float s = blinnphong(r, l, m) * attn ;

	l.c *= o * attn;
	
	r.c  = m.dc * l.c * d;
	r.c += i*r.l/distance(r.p,v.p);
	r.c += f * m.sc * l.c * s;
	return r;
}

float schlick(const in ray r, const in view v, const in mat m)
{
	float f = dot(r.n, v.d);
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

float ao(const in ray r)
{
	float o = 1.0;
	float l = 0.0;
	for(int i=0; i<=maxao; i++)
	{
		l += 0.1;
		float ml = map(r.p + r.n * l);
		o *= 1.0 - max(0.0, (l - ml) * 0.2 / l );                                   
	}
       
	return o;
}

float shadow(const in ray r, const in light l, const in float attn)
{
	float b = .008;
	ray s;
	s.d = l.d;
	s.p = r.p+r.n*b;
	s.l = -attn;
	float sl;
	for(int i = 0; i < maxs; i++){
		sl = map(s.p);
		s.p += sl*s.d;
		s.l += sl;
		
		if(sl-phi < attn) {s.l = 0.; break;}
		
		s.l = min(s.l, (b * sl) / float(maxs));
	}
	
	return clamp(s.l, 0., 1.);
}

vec3 gi(vec4 n){ 
	
	vec4 x1 = vec4(0.35,0.1, 0.45,0.12  );
	vec4 y1 = vec4(0.3,0.2, 0.3,0.1  );
	vec4 z1 = vec4(0.2,0.5,-0.1,0.13 );
	vec4 x2 = vec4(0.3,0.3 ,0.1,0. );
	vec4 y2 = vec4(0.2,0.2 ,0. ,0. );
	vec4 z2 = vec4(0.3 ,0.1 ,0. ,0.1 );
	vec3 w  = vec3(0.1 ,0. ,0.2 );
	
	vec3 l1;
	vec3 l2;
	vec3 l3;
	
	l1.r = dot(x1,n);
	l1.g = dot(y1,n);
	l1.b = dot(z1,n);
	
	vec4 m2 = n.xyzz * n.yzzx;
	l2.r = dot(x2,m2);
	l2.g = dot(y2,m2);
	l2.b = dot(z2,m2);
	
	float m3 = n.x*n.x - n.y*n.y;
	l3 = w * m3;
    	
	vec3 sh = vec3(l1 + l2 + l3);
	
	return clamp(sh, 0., 1.);
}

float sphere(const in vec3 p, const in float r){
	return length(p)-r;
}

float cuboid(const in vec3 p, const in vec3 s )
{
	vec3 d = (abs(p) - s);
	return max(d.x, max(d.y, d.z));
}