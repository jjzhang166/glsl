#ifdef GL_ES
precision mediump float;
#endif

// Mods by Dennis Hjorth -- @dennishjorth

// An unfinished hyperbolic space renderer by Kabuto. Something's still wrong with the math stuff - or is it the crappy shader compiler?
// Version 2: speed improvements

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float a = 1.61803398874989484820; // (sqrt(5)+1)/2
const float b = 2.05817102727149225032; // sqrt(2+sqrt(5))
const float c = 1.27201964951406896425; // sqrt((sqrt(5)+1)/2)
const float d = 2.61803398874989484820; // (sqrt(5)+3)/2


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

float edgeDist(vec3 pos) {
	// TODO get rid of artifacts visible at some corners
	pos = abs(pos);

	vec3 k = (pos.xyz*a+pos.yzx*(1.-a)+pos.zxy*-1.)/(2.*a*a+2.-2.*a);
	vec3 l = (pos.xyz*a + pos.yzx*(1.+a) + pos.zxy*1. - 2.*c)/(2.*a*a+2.+2.*a);
	vec3 m = k*k+l*l;
	vec3 n = pos.zxy-c/a;
	vec3 o = min(m, (pos*pos+n*n)*0.25);

	return sqrt(min(min(o.x, o.y), min(o.z,0.001)))*sqrt(1000.);
}

vec3 mirror0(vec3 pos, vec3 dir, float f, float g) {
	float threshold = 0.001;
	vec3 pos2 = pos + threshold*dir;
	vec4 hpos2 = vec4(pos2, 1.)*inversesqrt(1.-dot(pos2,pos2)); 
	// mirror hpos2 (hpos should stay the same since it's lying on the plane)
	f = -f;
	g = -g;
	hpos2 = hpos2*mat4(
	 -a,  a*f,  0, -b*g,
	  a*f,  0,  0,  c*f*g,
	  0,  0,  1,  0,
	  b*g, -c*f*g,  0,  d
	);
	pos2 = hpos2.xyz/hpos2.w;
	return normalize(pos2-pos);
}

vec4 reflect(vec3 pos, vec3 dir, float l) {
	float face = 12.0;
	float threshold = 0.00001;
	vec3 dir2 = vec3(0);
	vec3 pos2 = pos + l*dir;
	vec3 apos2 = abs(pos2);
	float tx = apos2.x*a+apos2.y;
	float ty = apos2.y*a+apos2.z;
	float tz = apos2.z*a+apos2.x;
	if (tx > ty && tx > tz) {
		dir2 = mirror0(pos2.xyz,dir.xyz,sign(pos2.y)*sign(pos2.x),sign(pos2.x)).xyz;
	} else if (ty > tz) {
		dir2 = mirror0(pos2.yzx,dir.yzx,sign(pos2.z)*sign(pos2.y),sign(pos2.y)).zxy;
	} else {
		dir2 = mirror0(pos2.zxy,dir.zxy,sign(pos2.x)*sign(pos2.z),sign(pos2.z)).yzx;
	}
	return vec4(dir2, face);
}



void main( void ) {

	vec3 dir = normalize(vec3(gl_FragCoord.x / resolution.x - 0.5, (gl_FragCoord.y - resolution.y * 0.5) / resolution.x, 0.5));
	float tf = 0.; // TODO add proper hyperbolic space math fract(time)-0.5;
	vec3 pos = vec3(mouse-0.5, 0)+tf*vec3(-1.,0,a)*0.5;
	
	dir.x += cos(time*0.4)*0.2+0.3;
	dir.y += sin(time*0.8)*0.2+0.3;
	
	float cosvx = cos(time*1.2);
	float sinvx = sin(time*1.9);
	
	vec3 dir2;
	dir2.x = cosvx*dir.x+sinvx*dir.y;
	dir2.y = sinvx*dir.x-cosvx*dir.y;
	dir2.z = dir.z;
	
	dir = dir2; 
	
	
	pos.x = cos(time*0.7)*0.2+0.2;
	pos.y = sin(time*0.8)*0.2+0.2;
	
	float lq = 1.0;
	float face = 0.;
	// Loops unrolled by hand - for loops are destroyed by the f***ing shader compiler
	{
		float l = kleinDist(pos, dir);
		lq *= edgeDist(pos+dir*l);
		
		// Which face did we collide with?
		float threshold = 0.00001;
		vec4 pv = reflect(pos, dir, l);
		face += pv.w;
		
		pos += dir*l+pv.xyz*threshold;
		dir = pv.xyz;
	}
	{
		float l = kleinDist(pos, dir);
		lq *= edgeDist(pos+dir*l);
		
		// Which face did we collide with?
		float threshold = 0.00001;
		vec4 pv = reflect(pos, dir, l);
		face += pv.w;
		
		pos += dir*l+pv.xyz*threshold;
		dir = pv.xyz;
	}
	{
		float l = kleinDist(pos, dir);
		lq *= edgeDist(pos+dir*l);
		
		// Which face did we collide with?
		float threshold = 0.00001;
		vec4 pv = reflect(pos, dir, l);
		face += pv.w;
		
		pos += dir*l+pv.xyz*threshold;
		dir = pv.xyz;
	}
	{
		float l = kleinDist(pos, dir);
		lq *= edgeDist(pos+dir*l);
		
		// Which face did we collide with?
		float threshold = 0.00001;
		vec4 pv = reflect(pos, dir, l);
		face += pv.w;
		
		pos += dir*l+pv.xyz*threshold;
		dir = pv.xyz;
	}
	{
		float l = kleinDist(pos, dir);
		lq *= edgeDist(pos+dir*l);
		
		// Which face did we collide with?
		float threshold = 0.00001;
		vec4 pv = reflect(pos, dir, l);
		face += pv.w;
		
		pos += dir*l+pv.xyz*threshold;
		dir = pv.xyz;
	}
	{
		float l = kleinDist(pos, dir);
		lq *= edgeDist(pos+dir*l+l);
		
		// Which face did we collide with?
		float threshold = 0.00001;
		vec4 pv = reflect(pos, dir, l);
		face += pv.w;
		
		pos += dir*l+pv.xyz*threshold;
		dir = pv.xyz;
	}
	lq = 1.-lq;
	gl_FragColor = vec4(pow(cos(time+lq),3.), pow(sin(time-lq),time), mod(time,lq), 1.0 );

}