#ifdef GL_ES
precision mediump float;
#endif

// A hyperbolic space renderer by Kabuto
// Modified, added some nice reflections :)

// Hold your mouse pointer near the left edge to look forward, near the center to look sideways and near the right edge to look backward

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
	return min(min(o.x, o.y), o.z);
}

// Mirrors dir in hyperbolic space across the selected outer face of the polyhedron. All inputs and outputs given in klein metric
vec3 reflect0(vec3 pos, vec3 dir, float f, float g) {
	float threshold = 0.001;
	vec3 pos2 = pos + threshold*dir;
	vec4 hpos2 = vec4(pos2, 1.)*inversesqrt(1.-dot(pos2,pos2)); 
	hpos2 = hpos2*mat4(
	 -a,  -a*f*g,  0, b*g,
	  -a*f*g,  0,  0,  c*f,
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

float sinh(float f) {
	return (exp(f)-exp(-f))*0.5;
}

vec4 hypervec(vec3 norm, float dist) {
	float sinh = (exp(dist)-exp(-dist))*0.5;
	return vec4(norm*sinh, sqrt(sinh*sinh+1.0));
}

vec4 kleinToHyper(vec3 klein) {
	return vec4(klein, 1.)*inversesqrt(1.-dot(klein,klein));
}

float hyperdist(vec4 a, vec4 b) {
	float lcosh = dot(a,b*vec4(-1,-1,-1,1));
	return log(lcosh+sqrt(lcosh*lcosh-1.));
}

void main( void ) {
	float f = fract(time*0.1);
	float fs = sign(f-.5);
	vec3 dir = normalize(vec3(vec2(gl_FragCoord.x / resolution.x - 0.5, (gl_FragCoord.y - resolution.y * 0.5) / resolution.x), 0.5));
	
	float tcos, tsin;
	tcos = cos((mouse.y-.5)*2.1);
	tsin = sin(-(mouse.y-.5)*2.1);
	dir *= mat3(1,0,0,0,tcos,-tsin,0,tsin,tcos);
	tcos = cos((mouse.x-.1)*4.1);
	tsin = sin(-(mouse.x-.1)*4.1);
	dir *= mat3(tcos,0,-tsin,0,1,0,tsin,0,tcos);
	dir *= vec3(sign(f-.5),sign(f-.5),1.);
	
	vec4 hpos = vec4(0,0,0,1);
	vec4 hdir = hypervec(dir, 0.001);
	
	float psinh, pcosh;
	mat4 movemat;
	
	float mouselimit = max(.5,length(mouse-.5));
	
	psinh = sinh(cos(time*.1)*.3*fs);
	pcosh = sqrt(psinh*psinh+1.);
	movemat = mat4(1,0,0,0, 0,pcosh,0,psinh, 0,0,1,0, 0,psinh,0,pcosh);
	hpos *= movemat;
	hdir *= movemat;

	psinh = sinh(sin(time*.1)*.3*fs);
	pcosh = sqrt(psinh*psinh+1.);
	movemat = mat4(pcosh,0,0,psinh, 0,1,0,0, 0,0,1,0, psinh,0,0,pcosh);
	hpos *= movemat;
	hdir *= movemat;
	
	psinh = sinh((fract(f*2.)-.5)*a);
	pcosh = sqrt(psinh*psinh+1.);
	movemat = mat4(1,0,0,0, 0,1,0,0, 0,0,pcosh,psinh, 0,0,psinh,pcosh);
	hpos *= movemat;
	hdir *= movemat;
	
	vec3 pos = hpos.xyz/hpos.w;;
	dir = normalize(hdir.xyz/hdir.w-pos);
	
	
	float q = sqrt(a*a+1.0);
	mat3 mat = mat3(a,0,1, 0,q,0, -1.,0,a)/q;
	pos *= mat;
	dir *= mat;
	
	 hpos = kleinToHyper(pos);
	float odd = fs;
	
	vec3 color = vec3(0);
	float cremain = 1.0;

	const float maxrad2 = 0.6;
	const float refractIndex = 1.2;
	
	for (int i = 0; i < 14; i++) {
		float pd = dot(pos,dir);
		float sDist = (-pd+sqrt(pd*pd-dot(pos,pos)+maxrad2));
		float kDist = kleinDist(pos, dir);
		if (sDist < kDist) {
			pos += dir*sDist;
			dir = normalize(reflect(dir, -normalize(pos)));

			vec4 hpos2 = kleinToHyper(pos);
			cremain *= exp(-.2*hyperdist(hpos, hpos2));
			hpos = hpos2;
			color += cremain*0.3*vec3(0.3+0.3*odd,.3,0.3-0.3*odd);
			cremain *= 0.7;
		} else {
			pos += dir*kDist;
			vec4 hpos2 = kleinToHyper(pos);
			cremain *= exp(-.2*hyperdist(hpos, hpos2));
			hpos = hpos2;
			
			float edge = edgeDist(pos);
			if (cremain < .003) { break;}
			dir = hreflect(pos, dir);
			odd = -odd;
		}
	}
	
	gl_FragColor = vec4(color*2.5, 1.);

}