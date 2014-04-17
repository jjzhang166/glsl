#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


//3d without raytracing

//could probably speed it up with vertices and indices rather than a big array of triangles
//people better at glsl than I make this faster pls

//adapted (stolen) from http://stackoverflow.com/questions/2049582/how-to-determine-a-point-in-a-triangle


#define VERTS 36
#define PI 3.14159

float side(vec2 p1, vec2 p2, vec2 p3){
	return (p1.x - p3.x) * (p2.y - p3.y) - (p2.x - p3.x) * (p1.y - p3.y);
}

float tri(vec2 pt, vec2 v1, vec2 v2, vec2 v3){
	bool b1, b2, b3;
	
	b1 = side(pt, v1, v2) < 0.;
	b2 = side(pt, v2, v3) < 0.;
	b3 = side(pt, v3, v1) < 0.;
	
	if((b1 == b2) && (b2 == b3)){
		return 1.;
	}
	return 0.;
}

vec2 project(vec3 p){
	p+=vec3(0.,0.,-10.);
	return vec2(p.x/p.z,p.y/p.z)+vec2(0.5,0.5);
}

vec3 roty(vec3 p,float r){
	return vec3(p.x*cos(r)+p.z*sin(r),p.y,p.z*cos(r)-p.x*sin(r));	
}
vec3 rotx(vec3 p,float r){
	return vec3(p.x,p.y*cos(r)-p.z*sin(r),p.z*cos(r)+p.y*sin(r));	
}
void main( void ) {
	vec3 points[VERTS];
	points[0]=vec3(-1.,-1.,-1.);
	points[1]=vec3(1.,-1.,-1.);
	points[2]=vec3(1.,1.,-1.);
	points[3]=vec3(-1.,1.,-1.);
	points[4]=vec3(-1.,-1.,-1.);
	points[5]=vec3(1.,1.,-1.);
	
	points[6]=vec3(-1.,-1.,1.);
	points[7]=vec3(1.,-1.,-1.);
	points[8]=vec3(-1.,-1.,-1.);
	points[9]=vec3(1.,-1.,1.);
	points[10]=vec3(1.,-1.,-1.);
	points[11]=vec3(-1.,-1.,1.);
	
	points[12]=vec3(-1.,-1.,-1.);
	points[13]=vec3(-1.,1.,-1.);
	points[14]=vec3(-1.,1.,1.);
	points[15]=vec3(-1.,-1.,1.);
	points[16]=vec3(-1.,-1.,-1.);
	points[17]=vec3(-1.,1.,1.);
	
	points[18]=vec3(1.,1.,1.);
	points[19]=vec3(1.,-1.,1.);
	points[20]=vec3(-1.,-1.,1.);
	points[21]=vec3(1.,1.,1.);
	points[22]=vec3(-1.,-1.,1.);
	points[23]=vec3(-1.,1.,1.);
	
	points[24]=vec3(-1.,1.,-1.);
	points[25]=vec3(1.,1.,-1.);
	points[26]=vec3(-1.,1.,1.);
	points[27]=vec3(-1.,1.,1.);
	points[28]=vec3(1.,1.,-1.);
	points[29]=vec3(1.,1.,1.);
	
	points[30]=vec3(1.,1.,1.);
	points[31]=vec3(1.,1.,-1.);
	points[32]=vec3(1.,-1.,-1.);
	points[33]=vec3(1.,1.,1.);
	points[34]=vec3(1.,-1.,-1.);
	points[35]=vec3(1.,-1.,1.);
	
	vec2 pos = ( gl_FragCoord.xy / resolution.y );
	vec3 col;
	
	for(int i=0;i<VERTS;i+=3){
		vec3 t1=rotx(roty(points[i],mouse.x*2.*PI),mouse.y*2.*PI);
		vec3 t2=rotx(roty(points[i+1],mouse.x*2.*PI),mouse.y*2.*PI);
		vec3 t3=rotx(roty(points[i+2],mouse.x*2.*PI),mouse.y*2.*PI);
		
		vec3 n=normalize(cross(t3-t2,t2-t1));
	
		float l=dot(n,vec3(0.,0.,1.));
		
		if(l<0.09){
			continue;
		}
		
		col.g+=l*tri(pos,
			project(t1),
			project(t2),
			project(t3)
			);
	}

	gl_FragColor = vec4( col, 1.0 );

}