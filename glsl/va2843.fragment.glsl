#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


mat4 rotate(vec3 a)
{
	mat4 ret;
	float angle = length(a);
	if (angle == 0.0) return mat4(1.0);
	a /= length(a);
	float c = cos(angle);
	float cinv = 1.0 - c;
	float s = sin(angle);
	
	return mat4(a.x*a.x*cinv + c, a.x*a.y*cinv + a.z*s, a.x*a.z*cinv - a.y*s,0.0,
		    a.x*a.y*cinv - a.z*s, a.y*a.y*cinv + c, a.y*a.z*cinv + a.x *s, 0.0,
		    a.x*a.z*cinv + a.y*s, a.y*a.z*cinv - a.x*s,a.z*a.z*cinv + c,0.0,
		    0.0,0.0,0.0,1.0
		);
}
/*
float det(mat4 data)
{	
return	data[ 0][ 0]*data[ 1][ 1]*data[ 2][ 2]*data[ 3][ 3] + data[ 0][ 0]*data[ 2][ 1]*data[ 3][ 2]*data[ 1][ 3] + data[ 0][ 0]*data[ 3][ 1]*data[ 1][ 2]*data[ 2][ 3] +
			data[ 1][ 0]*data[ 0][ 1]*data[ 3][ 2]*data[ 2][ 3] + data[ 1][ 0]*data[ 2][ 1]*data[ 0][ 2]*data[ 3][ 3] + data[ 1][ 0]*data[ 3][ 1]*data[ 2][ 2]*data[ 0][ 3] +
 			data[ 2][ 0]*data[ 0][ 1]*data[ 1][ 2]*data[ 3][ 3] + data[ 2][ 0]*data[ 1][ 1]*data[ 3][ 2]*data[ 0][ 3] + data[ 2][ 0]*data[ 3][ 1]*data[ 0][ 2]*data[ 1][ 3] +
			data[ 3][ 0]*data[ 0][ 1]*data[ 2][ 2]*data[ 1][ 3] + data[ 3][ 0]*data[ 1][ 1]*data[ 0][ 2]*data[ 2][ 3] + data[ 3][ 0]*data[ 2][ 1]*data[ 1][ 2]*data[ 0][ 3] -
 			data[ 0][ 0]*data[ 1][ 1]*data[ 3][ 2]*data[ 2][ 3] - data[ 0][ 0]*data[ 2][ 1]*data[ 1][ 2]*data[ 3][ 3] - data[ 0][ 0]*data[ 3][ 1]*data[ 2][ 2]*data[ 1][ 3] -
			data[ 1][ 0]*data[ 0][ 1]*data[ 2][ 2]*data[ 3][ 3] - data[ 1][ 0]*data[ 2][ 1]*data[ 3][ 2]*data[ 0][ 3] - data[ 1][ 0]*data[ 3][ 1]*data[ 0][ 2]*data[ 2][ 3] -
			data[ 2][ 0]*data[ 0][ 1]*data[ 3][ 2]*data[ 1][ 3] - data[ 2][ 0]*data[ 1][ 1]*data[ 0][ 2]*data[ 3][ 3] - data[ 2][ 0]*data[ 3][ 1]*data[ 1][ 2]*data[ 0][ 3] -
			data[ 3][ 0]*data[ 0][ 1]*data[ 1][ 2]*data[ 2][ 3] - data[ 3][ 0]*data[ 1][ 1]*data[ 2][ 2]*data[ 0][ 3] - data[ 3][ 0]*data[ 2][ 1]*data[ 0][ 2]*data[ 1][ 3];
}

mat4 inverse(mat4 data)
{
	mat4 mat = mat4(1.0);
	float determ = det(data);
	if (determ == 0.0) return mat;
	
	mat[0][0] = data[1][1]*data[2][2]*data[3][3] + data[2][1]*data[3][2]*data[1][3] + data[3][1]*data[1][2]*data[2][3] - data[1][1]*data[3][2]*data[2][3] - data[2][1]*data[1][2]*data[3][3] - data[3][1]*data[2][2]*data[1][3];
 	mat[1][0] = data[1][0]*data[3][2]*data[2][3] + data[2][0]*data[1][2]*data[3][3] + data[3][0]*data[2][2]*data[1][3] - data[1][0]*data[2][2]*data[3][3] - data[2][0]*data[3][2]*data[1][3] - data[3][0]*data[1][2]*data[2][3];
 	mat[2][0] = data[1][0]*data[2][1]*data[3][3] + data[2][0]*data[3][1]*data[1][3] + data[3][0]*data[1][1]*data[2][3] - data[1][0]*data[3][1]*data[2][3] - data[2][0]*data[1][1]*data[3][3] - data[3][0]*data[2][1]*data[1][3];
 	mat[3][0] = data[1][0]*data[3][1]*data[2][2] + data[2][0]*data[1][1]*data[3][2] + data[3][0]*data[2][1]*data[1][2] - data[1][0]*data[2][1]*data[3][2] - data[2][0]*data[3][1]*data[1][2] - data[3][0]*data[1][1]*data[2][2];
	mat[0][1] = data[0][1]*data[3][2]*data[2][3] + data[2][1]*data[0][2]*data[3][3] + data[3][1]*data[2][2]*data[0][3] - data[0][1]*data[2][2]*data[3][3] - data[2][1]*data[3][2]*data[0][3] - data[3][1]*data[0][2]*data[2][3];
 	mat[1][1] = data[0][0]*data[2][2]*data[3][3] + data[2][0]*data[3][2]*data[0][3] + data[3][0]*data[0][2]*data[2][3] - data[0][0]*data[3][2]*data[2][3] - data[2][0]*data[0][2]*data[3][3] - data[3][0]*data[2][2]*data[0][3];
	mat[2][1] = data[0][0]*data[3][1]*data[2][3] + data[2][0]*data[0][1]*data[3][3] + data[3][0]*data[2][1]*data[0][3] - data[0][0]*data[2][1]*data[3][3] - data[2][0]*data[3][1]*data[0][3] - data[3][0]*data[0][1]*data[2][3];
 	mat[3][1] = data[0][0]*data[2][1]*data[3][2] + data[2][0]*data[3][1]*data[0][2] + data[3][0]*data[0][1]*data[2][2] - data[0][0]*data[3][1]*data[2][2] - data[2][0]*data[0][1]*data[3][2] - data[3][0]*data[2][1]*data[0][2];
 	mat[0][2] = data[0][1]*data[1][2]*data[3][3] + data[1][1]*data[3][2]*data[0][3] + data[3][1]*data[0][2]*data[1][3] - data[0][1]*data[3][2]*data[1][3] - data[1][1]*data[0][2]*data[3][3] - data[3][1]*data[1][2]*data[0][3];
 	mat[1][2] = data[0][0]*data[3][2]*data[1][3] + data[1][0]*data[0][2]*data[3][3] + data[3][0]*data[1][2]*data[0][3] - data[0][0]*data[1][2]*data[3][3] - data[1][0]*data[3][2]*data[0][3] - data[3][0]*data[0][2]*data[1][3];
 	mat[2][2] = data[0][0]*data[1][1]*data[3][3] + data[1][0]*data[3][1]*data[0][3] + data[3][0]*data[0][1]*data[1][3] - data[0][0]*data[3][1]*data[1][3] - data[1][0]*data[0][1]*data[3][3] - data[3][0]*data[1][1]*data[0][3];
 	mat[3][2] = data[0][0]*data[3][1]*data[1][2] + data[1][0]*data[0][1]*data[3][2] + data[3][0]*data[1][1]*data[0][2] - data[0][0]*data[1][1]*data[3][2] - data[1][0]*data[3][1]*data[0][2] - data[3][0]*data[0][1]*data[1][2];
 	mat[0][3] = data[0][1]*data[2][2]*data[1][3] + data[1][1]*data[0][2]*data[2][3] + data[2][1]*data[1][2]*data[0][3] - data[0][1]*data[1][2]*data[2][3] - data[1][1]*data[2][2]*data[0][3] - data[2][1]*data[0][2]*data[1][3];
 	mat[1][3] = data[0][0]*data[1][2]*data[2][3] + data[1][0]*data[2][2]*data[0][3] + data[2][0]*data[0][2]*data[1][3] - data[0][0]*data[2][2]*data[1][3] - data[1][0]*data[0][2]*data[2][3] - data[2][0]*data[1][2]*data[0][3];
 	mat[2][3] = data[0][0]*data[2][1]*data[1][3] + data[1][0]*data[0][1]*data[2][3] + data[2][0]*data[1][1]*data[0][3] - data[0][0]*data[1][1]*data[2][3] - data[1][0]*data[2][1]*data[0][3] - data[2][0]*data[0][1]*data[1][3];
 	mat[3][3] = data[0][0]*data[1][1]*data[2][2] + data[1][0]*data[2][1]*data[0][2] + data[2][0]*data[0][1]*data[1][2] - data[0][0]*data[2][1]*data[1][2] - data[1][0]*data[0][1]*data[2][2] - data[2][0]*data[1][1]*data[0][2];
 		
	
	determ = 1.0/determ;
	for (int x = 0; x < 4; ++x)
	for (int y = 0; y < 4; ++y)
		mat[x][y] *= determ;
	return mat;
}
*/
mat4 translate(vec3 t)
{
	return mat4(1.0,0.0,0.0,0.0,
		    0.0,1.0,0.0,0.0,
		    0.0,0.0,1.0,0.0,
		    t.x,t.y,t.z,1.0);
}


struct Hit
{
	vec4 hitpoint;
	vec4 normal;
	vec4 color;
	float lambda;
	float scalar;
	bool hit;
};

	
Hit nearest(Hit a,Hit b)
{
	if (!a.hit) return b;
	if (!b.hit) return a;
	if (b.lambda < a.lambda) return b; else return a;
}
	
	
Hit hitRectangle(vec4 op,vec4 od, mat4 rt, mat4 rtinv, vec3 dim)
{
	vec4 p = rtinv * op;
	vec4 d = rtinv * vec4(od.xyz,0.0);
	
	float lambda = -(p.z+dim.z)/d.z;
	p += d*lambda;

	Hit hit;
	hit.hit = (p.x >= -dim.x && p.x <= dim.x && p.y >= -dim.y && p.y <= dim.y && lambda > 0.001);
	hit.lambda = lambda;
	hit.hitpoint = op + od * lambda;
	hit.normal = rt * vec4(0.0,0.0,-1.0,0.0);
	hit.scalar = dot(d,vec4(0.0,0.0,1.0,0.0));
	return hit;
}


Hit hitCube(vec4 p, vec4 d, mat4 rt,mat4 rtinv, vec3 dim)
{
	Hit ret;

	//front
	ret = nearest(ret,hitRectangle(p,d,rt,rtinv,vec3(dim.x,dim.y,dim.z)));
	//back
	vec3 r;
	r = vec3(0.0,3.141592,0.0);
	ret = nearest(ret,hitRectangle(p,d,rt*rotate(r),rotate(-r)*rtinv,vec3(dim.x,dim.y,dim.z)));
	
	//left
	r = vec3(0.0,3.141592*0.5,0.0);
	ret = nearest(ret,hitRectangle(p,d,rt*rotate(r),rotate(-r)*rtinv,vec3(dim.z,dim.y,dim.x)));
	//right
	r = vec3(0.0,-3.141592*0.5,0.0);
	ret = nearest(ret,hitRectangle(p,d,rt*rotate(r),rotate(-r)*rtinv,vec3(dim.z,dim.y,dim.x)));
	
	//top
	r = vec3(3.141592*0.5,0.0,0.0);
	ret = nearest(ret,hitRectangle(p,d,rt*rotate(r),rotate(-r)*rtinv,vec3(dim.x,dim.z,dim.y)));
	
	//bottom
	r = vec3(-3.141592*0.5,0.0,0.0);
	ret = nearest(ret,hitRectangle(p,d,rt*rotate(r),rotate(-r)*rtinv,vec3(dim.x,dim.z,dim.y)));
	
	return ret;
}


Hit hitWorld(vec4 p,vec4 d)
{
	Hit best;
	best.hit = false;

	
	
//	best = nearest(best,hitRectangle(p,d,rotate(vec3(3.141592*0.5,0.0,0.0)),-rotate(vec3(3.141592*0.5,0.0,0.0)),vec3(20.0,20.0,0.0)));
	
	for (int num = 0; num < 20; ++num)
	{
		float offset = float(num);
		vec3 pos = vec3(6.0*sin(offset*234.0 + time*0.8),3.0 + 3.0*sin(offset*123.0 + time*0.95), 6.0*sin(offset*453.0 + time*0.7));
	vec3 rot = vec3(sin(offset*455.0 + time*0.8),sin(offset*1.2 + time*1.3),sin(offset*765.0 + time*0.9));
				
		best = nearest(best,hitCube(p,d,translate(pos)*rotate(rot),rotate(-rot)*translate(-pos),vec3(0.3,0.3,0.3)));
	}


	
	vec3 rot = vec3(0,time*1.3,0);
	vec3 pos = vec3(0.0);
	best = nearest(best,hitCube(p,d,translate(pos)*rotate(rot),rotate(-rot)*translate(-pos),vec3(3.0,3.0,3.0)));

	if (best.hit)	
	{
		best.color = vec4(clamp(best.scalar,0.3,1.0)*0.5,0.0,0.0,1.0);			
	}
	else best.color = vec4(0.0,0.0,0.0,0.0);
	
	
	return best;
}

vec4 trace(vec4 p,vec4 d)
{
	vec4 c;
	Hit hit;
	hit.hitpoint = p;
	hit = hitWorld(hit.hitpoint,d);
	if (!hit.hit) return c;
	d -= 2.0*dot(d,hit.normal)*hit.normal;
	c = hit.color;	
/*
	hit = hitWorld(hit.hitpoint,d);
	if (!hit.hit) return c;
	d -= 2.0*dot(d,hit.normal)*hit.normal;
	c += hit.color;	
*/	
	
	return c;
}


void main( void ) {


	mat4 vp;
	vp[0] = vec4(2.0*resolution.x/resolution.y,0.0,0.0,0.0);
	vp[1] = vec4(0.0,2.0,0.0,0.0);
	vp[2] = vec4(0.0,0.0,1.0,0.0);
	vp[3] = vec4(-(resolution.x/resolution.y),-1.0,0.0,1.0);


	mat4 cam = translate(vec3(0.0,5.0,0.0)) *  rotate(vec3(0.0,time,0.0))* rotate(vec3(-0.0,0.0,0.0)) * translate(vec3(0.0,0.0,10.0));
	
	float fd = 0.4;
	vec4 fp = cam * vec4(0.0,0.0,fd,1.0);
	
		
	vec4 p = cam * vp * vec4(gl_FragCoord.x/resolution.x,gl_FragCoord.y/resolution.y,0.0,1.0);
	vec4 d = p - fp;
	d /= length(d);
	

	vec4 color = vec4(0.0);
	

	gl_FragColor = trace(p,d);
	
	Hit hit = hitWorld(p,d);
	if (hit.hit)
	{
		gl_FragColor = hit.color;	
	}
	else gl_FragColor = vec4(0.0,0.0,0.0,1.0);
		
/*/*	
	if (hit.hit)
	{
		p = hit.p;
		d -= 2.0*dot(d,hit.normal)*hit.normal;			
		color += vec4(clamp(hit.scalar,0.3,1.0),0.0,0.0,1.0);			
		
		hit = hitWorld(p,d);
		if (hit.hit)
			color += vec4(clamp(hit.scalar,0.3,1.0),0.0,0.0,1.0);			

	}
*/

}