#ifdef GL_ES
precision mediump float;
#endif

// An unfinished hyperbolic space renderer by Kabuto.
// Version 2: less artifacts, much faster, better comments :-)

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float a = 1.61803398874989484820; // (sqrt(5)+1)/2
const float b = 2.05817102727149225032; // sqrt(2+sqrt(5))
const float c = 1.27201964951406896425; // sqrt((sqrt(5)+1)/2)
const float d = 2.61803398874989484820; // (sqrt(5)+3)/2

// Distance to the face of the enclosing polyhedron, given that all vectors are using klein metric
float kleinDist(vec3 pos, vec3 dir) {
	float q0 = dot(dir, vec3(a,+1.,0.));
	float l0 = (-dot(pos,vec3(a,+1.,0.)) + c*sign(q0)) / q0;
	float q1 = dot(dir, vec3(a,-1.,0.));
	float l1 = (-dot(pos,vec3(a,-1.,0.)) + c*sign(q1)) / q1;
	float q2 = dot(dir, vec3(0.,a,+1.));
	float l2 = (-dot(pos,vec3(0.,a,+1.)) + c*sign(q2)) / q2;
	float q3 = dot(dir, vec3(0.,a,-1.));
	float l3 = (-dot(pos,vec3(0.,a,-1.)) + c*sign(q3)) / q3;
	float q4 = dot(dir, vec3(+1.,0.,a));
	float l4 = (-dot(pos,vec3(+1.,0.,a)) + c*sign(q4)) / q4;
	float q5 = dot(dir, vec3(-1.,0.,a));
	float l5 = (-dot(pos,vec3(-1.,0.,a)) + c*sign(q5)) / q5;
	return min(min(min(l0,l1),min(l2,l3)),min(l4,l5));
}

// Distance to the nearest edge (klein metric)
float edgeDist(vec3 pos) {
	pos = abs(pos);
	vec3 o = c/a-max(pos, (pos.xyz*a + pos.yzx*(1.+a) + pos.zxy)/(2.*a));
	return min(min(o.x, o.y), min(o.z, 0.05))*20.0;
}

// Mirrors dir in hyperbolic space across the selected outer face of the polyhedron. All inputs and outputs given in klein metric
vec3 reflect0(vec3 pos, vec3 dir, float f, float g) {
	float threshold = 0.001;
	vec3 pos2 = pos + threshold*dir;
	vec4 hpos2 = vec4(pos2, 1.)*inversesqrt(1.-dot(pos2,pos2)); 
	hpos2 = hpos2*mat4(
	 -a,  -a*f*g,  0, b*g,
	  -a*f*g,  0,  0,  c/f,
	  0,  0,  1,  0,
	  -b*g, -c*f,  0,  d
	);
	pos2 = hpos2.xyz/hpos2.w;
	return normalize(pos2-pos);
}

// Selects the correct face and reflects dir
vec3 hreflect(vec3 pos2, vec3 dir) {
	float threshold = 0.00001;
	vec3 dir2 = vec3(0);
	vec3 apos2 = abs(pos2);
	float tx = apos2.x*a+apos2.y;
	float ty = apos2.y*a+apos2.z;
	float tz = apos2.z*a+apos2.x;
	if (tx > ty && tx > tz) {
		return reflect0(pos2.xyz,dir.xyz,sign(pos2.y),sign(pos2.x)).xyz;
	} else if (ty > tz) {
		return reflect0(pos2.yzx,dir.yzx,sign(pos2.z),sign(pos2.y)).zxy;
	} else {
		return reflect0(pos2.zxy,dir.zxy,sign(pos2.x),sign(pos2.z)).yzx;
	}
}



void main( void ) {

	float q = sqrt(a*a+1.0);
	float f = 0.7601;// fract(time*0.1);
	vec3 dir = normalize(vec3(vec2(gl_FragCoord.x / resolution.x - 0.5, (gl_FragCoord.y - resolution.y * 0.5) / resolution.x)*sign(f-.5), 0.5));
	float tf = (fract(f*2.)-0.5)*q*.5;
	vec3 pos = vec3(mouse-0.5, 0)*sign(f-.5);
	mat3 mat = mat3(a,0,1, 0,q,0, -1.,0,a)/q;
	pos *= mat;
	dir *= mat;
	
	float lq = 1.0;
	// TODO make result more uniform with level of detail depending on actual distance and not on the number of faces crossed so far
	for (int i = 0; i < 6; i++) {
		pos += dir*kleinDist(pos, dir);
		lq *= edgeDist(pos);
		dir = hreflect(pos, dir);
	}
	lq = 1.-lq;
	gl_FragColor = vec4(pow(lq,16.), pow(lq,4.), lq, 1.0 )*1.0;

}