#ifdef GL_ES
precision mediump float;
#endif

// Hyperbolic space, filled with cubes (6 around each edge) of infinite edge length and infinite node distance but still finite volume. Don't try to understand this ;-)  By Kabuto

// Panini fisheye, flying (almost :) ) into infinity

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float halfpi = asin(1.0);
float cos(float v){ // workaround for AMD Radeon HD on OS X
	return sin(v+halfpi);
}

const float m = 0.5773502691896258; // cube face distance

const float lineRad = .002; // width of a line (relative to screen size) (TODO correct relative to hyperbolic space)


const float S1_2 = 0.7071067812;
const float S1_3 = 0.5773502692;
const float S1_6 = 0.4082482905;
const float S2_3 = 0.8164965809;
//const mat3 mulmat = mat3(-S1_2,0,S1_2,S1_6,-S2_3,S1_6,S1_3,S1_3,S1_3);

const mat3 mulmat = mat3(-S1_2,S1_6,S1_3, 0,-S2_3,S1_3,  S1_2,S1_6,S1_3);


// Distance to the face of the enclosing polyhedron, given that all vectors are using klein metric
float kleinDist(vec3 pos, vec3 dir) {
	vec3 v = (m*sign(dir)-pos)/dir;
	return min(min(v.x,v.y),v.z);
}


// Mirrors dir in the klein metric on the outer face of the polyhedron (on which pos must lie)	p := (2*(p*v-m)*v + p*(m²-1))/((p*v)*2m-(m²+1))
vec3 hreflect(vec3 pos, vec3 dir) {
	vec3 apos = abs(pos);
	if (apos.x > max(apos.y,apos.z)) {
		return normalize(dir*(1.-m*m)+2.*sign(pos.x)*dir.x*m*pos - vec3(2.*dir.x,0,0));
	} else if (apos.y > apos.z) {
		return normalize(dir*(1.-m*m)+2.*sign(pos.y)*dir.y*m*pos - vec3(0,2.*dir.y,0));
	} else {
		return normalize(dir*(1.-m*m)+2.*sign(pos.z)*dir.z*m*pos - vec3(0,0,2.*dir.z));
	}
}

float sinh(float f) {
	return (exp(f)-exp(-f))*0.5;
}

float atanh(float f) {
	return log((1.+f)/(1.-f))*.5;
}

vec4 kleinToHyper(vec3 klein) {
	return vec4(klein, 1.)*inversesqrt(1.-dot(klein,klein));
}

float hyperdist(vec4 a, vec4 b) {
	float lcosh = dot(a,b*vec4(-1,-1,-1,1));
	return log(lcosh+sqrt(lcosh*lcosh-1.));
}

void main( void ) {
	// Compute camera path and angle
	float f0 = sin(time*.3)*6.;
	float fcx = 2.*( gl_FragCoord.x / resolution.x - 0.5);
	float fcy = 2.*((gl_FragCoord.y - resolution.y * 0.5) / resolution.x);
	float fcz = fcx*fcx+fcy*fcy+1.;
	
	vec3 dir = vec3(2.*fcx,2.*fcy,2.-fcz)/fcz;
	
	float tc = cos((mouse.y-.5)*2.1);
	float ts = sin(-(mouse.y-.5)*2.1);
	float uc = cos((mouse.x-.1)*4.1);
	float us = sin(-(mouse.x-.1)*4.1);

	dir *= mat3(uc,-ts*us,-tc*us,0,tc,-ts,us,ts*uc,tc*uc);
	
	float cs = sinh(f0*atanh(m));
	float cc = sqrt(cs*cs+1.);
	
	// As last step position & direction are rotated as camera would otherwise fly through an edge instead of a face
	vec3 pos = vec3(0,0,cs/cc);
	dir = normalize(vec3(dir.x*cc,dir.y*cc,dir.z));
	
	pos *= mulmat;
	dir *= mulmat;
	
	
	// Actual raytracing starts here
	
	vec4 hpos = kleinToHyper(pos); // remember position in hyperbolic coordinates
	//float odd = fs;		// "oddness" keeps track of reflection color
	
	vec3 color = vec3(0);
	float cremain = 1.0;	// remaining amount of color that can be contributed
	float hdist = 0.;

	for (int i = 0; i < 14; i++) {
		pos += dir*kleinDist(pos, dir);	// compute actual distance (as we're in the klein metric we can't simply do length(a-b) - we have to use
		vec4 hpos2 = kleinToHyper(pos);
		float hdistnow = hyperdist(hpos, hpos2);
		hdist += hdistnow;
		cremain *= exp(-.35*hdistnow); //... and simulate fog
		hpos = hpos2;

		vec3 apos = abs(pos);
		apos = max(apos,apos.yzx);
		float r = min(1.,(m-min(min(apos.x,apos.y),apos.z))/(sinh(hdist)*lineRad));
		color += (1.-r)*cremain*0.15*vec3(1.0,0.7,.4);
		cremain *= 0.85+r*.15;
		dir = hreflect(pos, dir);	// reflect off polyhedron (advanced math stuff) - simulates propagation into "next" polyhedron
	}
	
	
	gl_FragColor = vec4(color*4.5, 1.);

}