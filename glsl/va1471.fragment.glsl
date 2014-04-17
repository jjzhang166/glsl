#ifdef GL_ES
precision mediump float;
#endif

// There, I fixed it.

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float a = 1.63803398874989484820; // (sqrt(5)+1)/2
const float b = 2.04817102727149225032; // sqrt(2+sqrt(5))
const float c = 1.34201964951406896425; // sqrt((sqrt(5)+1)/2)
const float d = 2.60803398874989484820; // (sqrt(5)+3)/2


float kleinDist(vec3 pos, vec3 dir) {
	float l0 = (-dot(pos,vec3(a,+1.,0.)) + c) / dot(dir, vec3(a,+1.,0.));
	float l1 = (-dot(pos,vec3(a,+1.,0.)) - c) / dot(dir, vec3(a,+1.,0.));
	float l2 = (-dot(pos,vec3(a,-1.,0.)) + c) / dot(dir, vec3(a,-1.,0.));
	float l3 = (-dot(pos,vec3(a,-1.,0.)) - c) / dot(dir, vec3(a,-1.,0.));
	float l4 = (-dot(pos,vec3(0.,a,+1.)) + c) / dot(dir, vec3(0.,a,+1.));
	float l5 = (-dot(pos,vec3(0.,a,+1.)) - c) / dot(dir, vec3(0.,a,+1.));
	float l6 = (-dot(pos,vec3(0.,a,-1.)) + c) / dot(dir, vec3(0.,a,-1.));
	float l7 = (-dot(pos,vec3(0.,a,-1.)) - c) / dot(dir, vec3(0.,a,-1.));
	float l8 = (-dot(pos,vec3(+1.,0.,a)) + c) / dot(dir, vec3(+1.,0.,a));
	float l9 = (-dot(pos,vec3(+1.,0.,a)) - c) / dot(dir, vec3(+1.,0.,a));
	float la = (-dot(pos,vec3(-1.,0.,a)) + c) / dot(dir, vec3(-1.,0.,a));
	float lb = (-dot(pos,vec3(-1.,0.,a)) - c) / dot(dir, vec3(-1.,0.,a));
	return 1./max(max(max(1./l0,1./l1),max(1./l2,1./l3)),max(max(max(1./l4,1./l5),max(1./l6,1./l7)),max(max(1./l8,1./l9),max(1./la,1./lb))));
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

vec3 mirror1(vec3 pos, vec3 dir, float f, float g) {
	return mirror0(pos.yzx, dir.yzx,f,g).zxy;
}

vec3 mirror2(vec3 pos, vec3 dir, float f, float g) {
	return mirror0(pos.zxy,dir.zxy,f,g).yzx;
}

vec4 reflect(vec3 pos, vec3 dir, float l) {
	float face = 12.0;
	float threshold = 0.00001;
	vec3 dir2 = vec3(0);
	vec3 pos2 = pos + l*dir;
	if (abs(l-(-dot(pos,vec3(a,+1.,0.)) + c) / dot(dir, vec3(a,+1.,0.))) < threshold)       { face = 0.0; dir2 = mirror0(pos2,dir,1.,1.); }
	else  if (abs(l-(-dot(pos,vec3(a,+1.,0.)) - c) / dot(dir, vec3(a,+1.,0.))) < threshold) { face = 1.0; dir2 = mirror0(pos2,dir,1.,-1.); }
	else  if (abs(l-(-dot(pos,vec3(a,-1.,0.)) + c) / dot(dir, vec3(a,-1.,0.))) < threshold) { face = 2.0; dir2 = mirror0(pos2,dir,-1.,1.); }
	else  if (abs(l-(-dot(pos,vec3(a,-1.,0.)) - c) / dot(dir, vec3(a,-1.,0.))) < threshold) { face = 3.0; dir2 = mirror0(pos2,dir,-1.,-1.); }
	else  if (abs(l-(-dot(pos,vec3(0.,a,+1.)) + c) / dot(dir, vec3(0.,a,+1.))) < threshold) { face = 4.0; dir2 = mirror1(pos2,dir,1.,1.); }
	else  if (abs(l-(-dot(pos,vec3(0.,a,+1.)) - c) / dot(dir, vec3(0.,a,+1.))) < threshold) { face = 5.0; dir2 = mirror1(pos2,dir,1.,-1.); }
	else  if (abs(l-(-dot(pos,vec3(0.,a,-1.)) + c) / dot(dir, vec3(0.,a,-1.))) < threshold) { face = 6.0; dir2 = mirror1(pos2,dir,-1.,1.); }
	else  if (abs(l-(-dot(pos,vec3(0.,a,-1.)) - c) / dot(dir, vec3(0.,a,-1.))) < threshold) { face = 7.0; dir2 = mirror1(pos2,dir,-1.,-1.); }
	else  if (abs(l-(-dot(pos,vec3(+1.,0.,a)) + c) / dot(dir, vec3(+1.,0.,a))) < threshold) { face = 8.0; dir2 = mirror2(pos2,dir,1.,1.); }
	else  if (abs(l-(-dot(pos,vec3(+1.,0.,a)) - c) / dot(dir, vec3(+1.,0.,a))) < threshold) { face = 9.0; dir2 = mirror2(pos2,dir,1.,-1.); }
	else  if (abs(l-(-dot(pos,vec3(-1.,0.,a)) + c) / dot(dir, vec3(-1.,0.,a))) < threshold) { face = 10.0;dir2 = mirror2(pos2,dir,-1.,1.); }
	else  if (abs(l-(-dot(pos,vec3(-1.,0.,a)) - c) / dot(dir, vec3(-1.,0.,a))) < threshold) { face = 11.0;dir2 = mirror2(pos2,dir,-1.,-1.); }
	return vec4(dir2, face);
}



void main( void ) {

	vec3 dir = normalize(vec3(gl_FragCoord.x / resolution.x - 0.5, (gl_FragCoord.y - resolution.y * 0.5) / resolution.x, 0.5));
	float tf = 0.; // TODO add proper hyperbolic space math fract(time)-0.5;
	vec3 pos = vec3(mouse-0.5, -0.5)+tf*vec3(-1.0,0,a)*0.5;
	
	float lq = 10.0;
	float face = 0.;
	float threshold = 0.00001;
	// Loops unrolled by hand - for loops are destroyed by the f***ing shader compiler
	{
		float l = kleinDist(pos, dir);
		lq = min(lq,kleinDist(pos+dir*(l+.00001),dir));
		
		// Which face did we collide with?
		
		vec4 pv = reflect(pos, dir, l);
		face += pv.w;
		
		pos += dir*l+pv.xyz*threshold;
		dir = pv.xyz;
	}
	{
		float l = kleinDist(pos, dir);
		lq = min(lq,kleinDist(pos+dir*(l+.00001),dir));
		
		// Which face did we collide with?

		vec4 pv = reflect(pos, dir, l);
		face += pv.w;
		
		pos += dir*l+pv.xyz*threshold;
		dir = pv.xyz;
	}
	{
		float l = kleinDist(pos, dir);
		lq = min(lq,kleinDist(pos+dir*(l+.00001),dir));
		
		// Which face did we collide with?

		vec4 pv = reflect(pos, dir, l);
		face += pv.w;
		
		pos += dir*l+pv.xyz*threshold;
		dir = pv.xyz;
	}
	{
		float l = kleinDist(pos, dir);
		lq = min(lq,kleinDist(pos+dir*(l+.00001),dir));
		
		// Which face did we collide with?

		vec4 pv = reflect(pos, dir, l);
		face += pv.w;
		
		pos += dir*l+pv.xyz*threshold;
		dir = pv.xyz;
	}
	{
		float l = kleinDist(pos, dir);
		lq = min(lq,kleinDist(pos+dir*(l+.00001),dir));
		
		// Which face did we collide with?

		vec4 pv = reflect(pos, dir, l);
		face += pv.w;
		
		pos += dir*l+pv.xyz*threshold;
		dir = pv.xyz;
	}
	lq = 1.-lq;
	gl_FragColor = vec4(pow(lq,16.), pow(lq,6.), 1.0, 1.0 );

}