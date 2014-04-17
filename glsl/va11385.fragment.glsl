#ifdef GL_ES
precision mediump float;
#endif

//http://glsl.heroku.com/e#11342.0 //Thanks to Dima
//4d manifolds = more better  //sphinx (as he clearly demonstrated) - finishing it up 

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define phi   	.001
#define iter  	128
#define bound  	128.
#define epsilon vec4(0.00001, 0., 0., 0.0)

#define pi  3.1415926
#define hpi 1.5707963
#define tau 6.2831853

mat4 mat  = mat4 ( vec4 ( 1.0 , 0.0 , 0.0 , 0.0 ),
		   vec4 ( 0.0 , 1.0 , 0.0 , 0.0 ),
		   vec4 ( 0.0 , 0.0 , 1.0 , 0.0 ),
		   vec4 ( 0.0 , 0.0 , 0.0 , 1.0 ) );

struct ray{
	vec4 p;
	vec4 o;
	vec4 d;
	float l;
};
	
struct light{
	vec3 p;
	vec3 c;
	float a;
};

float cube(vec4 v, vec4 size, vec4 position) {
	vec4 distance = abs(v + position) - size;
	vec4 distance_clamped = max(distance, 0.0);
	return length(distance_clamped) - 0.005;
}	
	
float sphere(vec3 p, float r){	
	return length(p) - r;
}	

float map(vec4 p){	
	
	vec4 o = vec4(0.);

	p.w -= time * .1;
	
	p *= mat;
	
	p = mod(p,8.);
	
	vec4 s  = vec4(8.);
	float c = cube(p, s,  o);
	
	float si = 7.;
	float inf = 65535.;
	vec2  ic = vec2(inf, si);
	float sx = cube(p, ic.xyyy, o);
	float sy = cube(p, ic.yxyy, o);
	float sz = cube(p, ic.yyxy, o);
	float sw = cube(p, ic.yyyx, o);
	
	float i = min(sx, min(sy, min( sz, sw)));
	
	return max(c, -i*64.);
}	

ray trace(ray r){
	float l = 0.;
	r.p += r.d * 4.;//nearclip
	for(int i = 0; i < iter; i++){
		l = map(r.p);
		if(l < phi){break;}
		r.p += r.d * l;
	}
	r.l = distance(r.p, r.o);
	return r;
}

vec4 derive(vec4 p){
	return normalize(vec4(map(p+epsilon.xzzz)-map(p-epsilon.xzzz),map(p+epsilon.zxzz)-map(p-epsilon.zxzz),map(p+epsilon.zzxz)-map(p-epsilon.zzxz),map(p+epsilon.zzzx)-map(p-epsilon.zzzx)));
}

vec3 shade(const in ray r, const in light l){
	vec3  c   = vec3(0.);
	vec3  n   = derive(r.p).xyz;
	float f   = .5 * (1.-r.l/float(iter));	
	
	vec3 ld   = normalize(l.p-r.p.xyz);
	
	float ndl = dot(n, ld);
	
	vec3 h 	  = normalize(ld - r.d.xyz);
	float ndh = max(0., dot(n, h));
	float s   = pow(ndh, 128.);
	
	float nf = 1.-f;
	
	c = l.c * ndl + nf * s;
	
	return c;
}

void rotate( float angle, float d1, float d2, float d3, float d4)
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
	r.o = vec4(0., 0., 32., 32.);
	r.p = r.o;
	r.d = normalize(vec4(p*2., 1., 1.));
	
	
	rotate ( time * .001, .0, 1.0, .0, 1.0 );
	rotate ( time * .063, 1.0, 0.0, 1.0, 0.0 );
	rotate ( time * .031, 1.0, 1.0, 0.0, 0.0 );
	rotate ( time * .015, 1.0, 0.0, 0.0, 1.0 );
	
	
	r = trace(r);

	light l;
	l.p = vec3(2.);
	l.c = vec3(.5, .5, .4);
	
	vec3 c = vec3(0.);
	
	if(r.l < bound){
		c = shade(r, l);
		vec4 rc = vec4(1.)*mat;
		c += (rc.xyz)*.25;
		c += abs(r.l*.025);
	}
	
	
	gl_FragColor = vec4(c, r.l);
}