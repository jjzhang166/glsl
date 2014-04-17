#ifdef GL_ES
precision highp float;
#endif

//http://glsl.heroku.com/e#11342.0 //Thanks to Dima
//4d manifolds = more better

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define phi   	.0001
#define iter  	64
#define bound  	16.
#define epsilon vec3(.001, 0., 0.)

#define pi  3.1415926
#define hpi 1.5707963
#define tau 6.2831853

mat4 mat  = mat4 ( vec4 ( 1.0 , 0.0 , 0.0 , 0.0 ),
		   vec4 ( 0.0 , 1.0 , 0.0 , 0.0 ),
		   vec4 ( 0.0 , 0.0 , 1.0 , 0.0 ),
		   vec4 ( 0.0 , 0.0 , 0.0 , 1.0 ) );

struct ray{
	vec3 p;
	vec3 o;
	vec3 d;
	float l;
};
	
struct light{
	vec3 p;
	vec3 c;
	float a;
};

float cube(vec3 v, vec3 size, vec3 position) {
	vec3 distance = abs(v + position) - size;
	vec3 distance_clamped = max(distance, 0.0);
	return length(distance_clamped) - 0.005;
}	
	
float sphere(vec3 p, float r){	
	return length(p) - r;
}	

float map(vec3 p){	
	vec4 p4 = vec4(p, -.1) * mat;
	vec3 o = vec3(0., 0., -1.);
	p-=o;
	float s0 = cube(p4.w*p, vec3(.55), p4.xyz);
	float s1 = cube(p4.w*p, vec3( 1024., .5, .5), p4.xyz);
	float s2 = cube(p4.w*p, vec3(.5,  1024., .5), p4.xyz);
	float s3 = cube(p4.w*p, vec3(.5, .5,  1024.), p4.xyz);
	return max(s0, -min(min(s1, s2), min(s2, s3)))+.0001;
}	

ray trace(ray r){
	float l = 0.;
	for(int i = 0; i < iter; i++){
		l = map(r.p);
		if(l < phi){break;}
		r.p += r.d * l;
	}
	r.l = distance(r.p, r.o);
	return r;
}

vec3 derive(vec3 p){
	return normalize(vec3(map(p+epsilon.xzz)-map(p-epsilon.xzz),map(p+epsilon.zxz)-map(p-epsilon.zxz),map(p+epsilon.zzx)-map(p-epsilon.zzx)));
}

vec3 shade(const in ray r, const in light l){
	vec3  c   = vec3(0.);
	vec3  n   = derive(r.p);
	float f   = .5 * (1.-r.l/float(iter));	
	
	vec3 ld   = normalize(l.p-r.p);
	
	float ndl = dot(n, ld);
	
	vec3 h 	  = normalize(ld - r.d);
	float ndh = max(0., dot(n, h));
	float s   = pow(ndh, 128.);
	
	float nf = 1.-f;
	
	c = l.c * ndl + nf * s;
	
	return c;
}

void Rotate ( float angle, float d1, float d2, float d3, float d4)
{
	float c = cos (angle), s = sin (angle);
	mat *= mat4 ( vec4 (  c*d1+(1.-d1),  s * d2 * d1 , -s * d3 * d1 ,  s * d4 * d1 ),
		      vec4 ( -s * d1 * d2 ,  c*d2+(1.-d2),  s * d3 * d2 , -s * d4 * d2 ),
		      vec4 (  s * d1 * d3 , -s * d2 * d3 ,  c*d3+(1.-d3),  s * d4 * d3 ),
		      vec4 ( -s * d1 * d4 ,  s * d2 * d4 , -s * d3 * d4 ,  c*d4+(1.-d4)) );
}

void main( void ) {
	float a = resolution.x/resolution.y;
	vec2 uv = gl_FragCoord.xy/resolution.xy;
	vec2 p  = uv * 2. - 1.;
	p.x *= a;

	ray r; 
	r.o = vec3(0., 0., 1.);
	r.p = r.o;
	r.d = vec3(p, -.5);
	
	Rotate ( time,       0.0, 1.0, 1.0, 0.0 );
	Rotate ( time * .63, 1.0, 0.0, 1.0, 0.0 );
	Rotate ( time * .31, 1.0, 1.0, 0.0, 0.0 );
	Rotate ( time * .15, 1.0, 0.0, 0.0, 1.0 );
	
	r = trace(r);

	light l;
	l.p = vec3(2.);
	l.c = vec3(.5, .5, .4);
	
	vec3 c = vec3(0.);
	
	if(r.l < bound){
		c = shade(r, l);
		vec4 rc = vec4(1.)*mat;
		c += (rc.xyz*rc.a)*.15;
		c += abs(r.l*.5);
	}
	
	
	gl_FragColor = vec4(c, r.l);
}