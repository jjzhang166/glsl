#ifdef GL_ES
precision mediump float;
#endif

// A hyperbolic space renderer by Kabuto
// Modified, added some nice reflections :)

// Hold your mouse pointer near the left edge to look forward, near the center to look sideways and near the right edge to look backward


// Change log:
// 
// Version 2:
// * Formulas optimized, no more hyperbolic space formulas, most matrices removed as well
// * Works on Intel GMA now and 30 percent faster on AMD (Nvidia untested but should be similar)
// * Lots of comments added
// * Not suitable for learning about hyperbolic geometry - there isn't much left of the original math. Consult parent versions if you're really interested.


// #### Circus mod ####

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float halfpi = asin(1.0);
float cos(float v){ // workaround for AMD Radeon HD on OS X
	return sin(v+halfpi);
}

// Constants used in many places
const float a = 1.61803398874989484820; // (sqrt(5)+1)/2
const float b = 2.05817102727149225032; // sqrt(2+sqrt(5))
const float c = 1.27201964951406896425; // sqrt((sqrt(5)+1)/2)
const float d = 2.61803398874989484820; // (sqrt(5)+3)/2
const float e = 1.90211303259030714423; // sqrt((sqrt(5)+5)/2);


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

// Distance to the nearest edge (klein metric) - albeit not used in this effect
float edgeDist(vec3 pos) {
	pos = abs(pos);
	vec3 o = c/a-max(pos, (pos.xyz*a + pos.yzx*(1.+a) + pos.zxy)/(2.*a));
	return min(min(o.x, o.y), o.z);
}

// Mirrors dir in the klein metric on the outer face of the polyhedron (on which pos must lie)
vec3 hreflect(vec3 pos, vec3 dir, inout vec4 fa, inout vec4 fb, inout vec4 fc) {
	vec3 s = sign(pos);
	vec3 apos2 = abs(pos);
	vec3 sdir = dir*s;
	vec3 q = apos2*a+apos2.yzx;
	if (q.x > q.y && q.x > q.z) {
		fa *= max(s.x*vec4(1,1,-1,-1),s.y*vec4(1,-1,1,-1));
		return normalize(pos*(c*sdir.y+b*sdir.x) + vec3(-a*(sdir.x+sdir.y),-a*sdir.x,sdir.z)*s);
	} else if (q.y > q.z) {
		fb *= max(s.y*vec4(1,1,-1,-1),s.z*vec4(1,-1,1,-1));
		return normalize(pos*(c*sdir.z+b*sdir.y) + vec3(sdir.x,-a*(sdir.y+sdir.z),-a*sdir.y)*s);
	} else {
		fc *= max(s.z*vec4(1,1,-1,-1),s.x*vec4(1,-1,1,-1));
		return normalize(pos*(c*sdir.x+b*sdir.z) + vec3(-a*sdir.z,sdir.y,-a*(sdir.z+sdir.x))*s);
	}
}

float sinh(float f) {
	return (exp(f)-exp(-f))*0.5;
}

vec4 kleinToHyper(vec3 klein) {
	return vec4(klein, 1.)*inversesqrt(1.-dot(klein,klein));
}

float hyperdist(vec4 a, vec4 b) {
	float lcosh = dot(a,b*vec4(-1,-1,-1,1));
	return log(lcosh+sqrt(lcosh*lcosh-1.));
}

// PRNG - turned out to be much better than the "mod 289" one
float random(float r) {
     return mod(floor(fract(r*0.1453451347234+0.7)*fract(r*0.7824754653+0.3)*6345.+fract(r*0.284256563424)*7254.),256.);
}

// Generates one stripe of perlin noise, ready to be combined with another stripe
float sperlin(float x, float y, float l, float r) {
	float xf = floor(x);
	x -= xf;
	float x0 = y+random(xf+r);
	float x1 = y+random(xf+r+1.);
	float a = (random(x0)-127.5)*x	 + (random(x0+128.)-127.5)*l;
	float b = (random(x1)-127.5)*(x-1.) + (random(x1+128.)-127.5)*l;
	return (a+(x*x*(3.-2.*x))*(b-a))/256.;
}

// 2D hyperbolic perlin noise - combines 2 stripes of 1D perlin noise
// x3,y3: coordinate within the unit disc (poincare metric)
// ntime: time (used to shift everything along the y axis without causing artifacts that easily occur when zooming the border instead)
// f: noise scale factor - 1 = coarse, < 1 = fine. Don't use > 1 as that gives artifacts
// r: PRNG offset (to get different noise in case you need multiple layers)
float hypperlin(float y3,float x3,float ntime,float f,float r) {
	ntime /= f;
	
	float div = sqrt(1.-x3*x3-y3*y3);

	float x = x3 / div;
	float y = y3 / div;
	float z = 1. / div;
	
	float ttime = floor(ntime);
	ntime -= ttime;
	ntime *= f;

	float v = (log(z+y)+ntime)/f;
	float s = x*(z-y)*exp(-ntime)/(x*x+1.);
	
	float v2 = floor(v);
	float l = v-v2;
	float xc = s*exp(v2*f)/f;
	float s2 = sperlin(xc,v2+ttime,l,r);
	float s3 = sperlin(xc*exp(f),v2+ttime+1.,l-1.,r);
	
	return s2+(s3-s2)*((6.*l-15.)*l+10.)*l*l*l;
}

vec3 colorAt(float x, float y, float time, float scale) {
	float h = (
		sqrt(abs(hypperlin(x,y,time,scale*0.5,0.)))
	)*4.;
	return floor(vec3(
		(hypperlin(x,y,time,scale,111.)+.3)*h,
		(hypperlin(x,y,time,scale,21.)+.3)*h,
		(hypperlin(x,y,time,scale,3.)+.3)*h
	)*3.+.5)/4.;
	
}

void main( void ) {
	// Compute camera path and angle
	float f0 = fract(time*0.05)+1e-5;
	float fl0 = floor(time*0.05*4.);
	float f = fract(f0*2.);
	float fs = sign(f-.5);
	float fs0 = sign(f0-.5);
	vec3 dir = normalize(vec3(vec2(gl_FragCoord.x / resolution.x - 0.5, (gl_FragCoord.y - resolution.y * 0.5) / resolution.x), 0.5));
	
	float tc = cos((mouse.y-.5)*2.1);
	float ts = sin(-(mouse.y-.5)*2.1);
	float uc = cos((mouse.x-.1)*4.1);
	float us = sin(-(mouse.x-.1)*4.1);

	dir *= mat3(uc,-ts*us,-tc*us,0,tc,-ts,us,ts*uc,tc*uc);
	//dir *= vec3(sign(f-.5),sign(f-.5),1.);
	dir.z *= fs;
	
	float as = (cos(time*.1)*.4);	// there was originally an outer sinh for as and bs but difference is just about 1 percent which doesn't really matter for the camera path
	float ac = sqrt(as*as+1.);
	float bs = (sin(time*.2)*.4);
	float bc = sqrt(bs*bs+1.);
	float cs = sinh((abs(f*2.-1.)-.5)*a);
	float cc = sqrt(cs*cs+1.);
	
	// As last step position & direction are rotated as camera would otherwise fly through an edge instead of a face
	float x = ac*bs;
	float z = ac*bc*cs;
	vec3 pos = vec3(x*a+z,as*e,-x+a*z)/(ac*bc*cc*e);
	//dir = fs;
	dir = normalize(vec3(dir.x*ac*cc-ac*bs*dir.z*cs,-as*dir.z*cs-dir.x*as*bs*cc+dir.y*bc*cc,ac*bc*dir.z)*mat3(a,0,1, 0,e,0, -1.,0,a));
	
	// Actual raytracing starts here
	
	vec4 hpos = kleinToHyper(pos); // remember position in hyperbolic coordinates
	//float odd = fs;		// "oddness" keeps track of reflection color
	
	//vec3 color = vec3(0);
	float cremain = 1.0;	// remaining amount of color that can be contributed

	vec4 fa = vec4(39.68454788472584,23.02644300941165,39.78873384183505,27.892411668925842);
	vec4 fb = vec4(29.507160029822894,32.10711839885068,35.17128234256937,26.70192179035261);
	vec4 fc = vec4(24.269388316732734,31.551200069547505,33.74895897903697,38.00825953283422);
	fc.x *= fs0*fs;
	fc.w *= fs0;
	
	// Assume a plane 
	mat3 mma = mat3(a,0,-1, 0,e,0, 1.,0,a)/e*mat3(0.96,0.28,0,-0.28,0.96,0,0,0,1);
	vec3 pos_s = pos*mma*vec3(1,1.8,1);
	vec3 dir_s2 = dir*mma*vec3(1,1.8,1);
	vec3 dir_s = normalize(dir_s2);
	float pd = dot(pos_s,dir_s);
	float pDist = (-pd+sqrt(pd*pd-dot(pos_s,pos_s)+1.))/length(dir_s2); // distance to sphere around origin (always there - camera isn't meant to ever be outside)

	float hpDist = hyperdist(hpos, kleinToHyper(pos+pDist*dir));
	float tDist = 0.;
	vec3 hpHit = pos+pDist*dir;
	
	vec3 color = colorAt((hpHit.z*a+hpHit.x)/e*fs, (hpHit.x*a-hpHit.z)/e,fl0*a,1.) * exp(-.3*(hpDist - tDist));
	
	for (int i = 0; i < 13; i++) {
		float pd = dot(pos,dir);
		float sDist = (-pd+sqrt(pd*pd-dot(pos,pos)+0.6)); // distance to sphere around origin (always there - camera isn't meant to ever be outside)
		float kDist = kleinDist(pos, dir);	// distance to enclosing polyhedron
		
		pos += dir*min(sDist,kDist);	// compute actual distance (as we're in the klein metric we can't simply do length(a-b) - we have to use
		vec4 hpos2 = kleinToHyper(pos);
		
		float stepDist = hyperdist(hpos, hpos2);
		tDist += stepDist;
		if (hpDist < tDist) {
			break;
		}
		
		cremain *= exp(-.3*stepDist); //... and simulate fog
		hpos = hpos2;
		
		if (sDist < kDist) {
			float s = dot(fa+fb+fc,vec4(1.));
			color = cremain*0.5*fract((fa.xyz+fb.xyz+fc.xyz)*(fc.yzw+fb.zwx+fa.wxy)+vec3(s))*(dot(dir,pos)+.5);
			
			break;
		} else {
			dir = hreflect(pos, dir,fa,fb,fc);	// reflect off polyhedron (advanced math stuff) - simulates propagation into "next" polyhedron
		}
	}
	
	
	gl_FragColor = vec4(color*2.5, 1.);

}