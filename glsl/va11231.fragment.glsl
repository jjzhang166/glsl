#ifdef GL_ES
precision highp float;
#endif

#define EPSILON 0.000001
#define MAX_DISTANCE 500.0

uniform vec2 resolution;
uniform float time;
uniform sampler2D tex0;
uniform sampler2D tex1;
uniform sampler2D fft;
uniform vec4 unPar;
uniform vec4 unPos;
uniform vec3 unBeatBassFFT;

vec3 pointLight = vec3(0.0,0.75,-1.5);

struct Triangle {
	vec3 v0;
	vec3 v1;
	vec3 v2;
};
	

 
float triangle_intersection(in vec3 v0, in vec3 v1, in vec3 v2, in vec3 ro, in vec3 rd) {
	
	
	
	
  
	vec3 e1, e2;  //Edge1, Edge2
  	vec3 P, Q, T;
  	float det, inv_det, u, v;
  	float t;
 
  	//Find vectors for two edges sharing V0
	e1 = v1 - v0;
	e2 = v2 - v0;
	
	// back face culling
	if (dot(cross(e1,e2),rd) < 0.0) {
		//return MAX_DISTANCE;
	}
	
  	//Begin calculating determinant - also used to calculate u parameter
	P = cross(rd,e2);
  	//if determinant is near zero, ray lies in plane of triangle
	det = dot(e1,P);
  	//NOT CULLING
  	if(det > -EPSILON && det < EPSILON) return MAX_DISTANCE;
  	inv_det = 1.0 / det;
 
  	//calculate distance from V0 to ray origin
	T = ro - v0;
 
  	//Calculate u parameter and test bound
	u = dot(T,P) * inv_det;
  	//The intersection lies outside of the triangle
  	if(u < 0.0 || u > 1.0) return MAX_DISTANCE;
 
  	//Prepare to test v parameter
	Q = cross(T,e1);
 
  	//Calculate V parameter and test bound
	v = dot(rd,Q) * inv_det;
  	//The intersection lies outside of the triangle
  	if(v < 0.0 || u + v  > 1.0) return MAX_DISTANCE;
	
	t = dot(e2,Q) * inv_det;
 
  	if(t > EPSILON) { //ray intersection
		return t;
  	}
 
  	// No hit, no win
  	return MAX_DISTANCE;
}

void someTest() {
	Triangle triangle;
	triangle.v0 = vec3(-0.4,0.6,-0.8);
	triangle.v1 = vec3(0.0,0.1,-1.4);
	triangle.v2 = vec3(0.4,0.6,-0.8);
	vec2 uv = vec2(1.0,1.0);
	vec3 ro = vec3(0.0,1.0,1.0);
	vec3 rd = normalize(vec3(-1.0 + 2.0*uv, -1.0));
	float inter0 = triangle_intersection(triangle.v0,triangle.v1,triangle.v2,ro,rd);
}

// Returns color of pixel
vec3 colourOfPixel(in vec2 uv) {
	vec3 col = vec3(0.0);
	
	// generate a ray
	vec3 ro = vec3(0.0,1.0,1.6);
	vec3 rd = normalize(vec3(-1.0 + 2.0*uv, -1.0));
	
	// create test triangle
	Triangle triangle;
	triangle.v0 = vec3(-1.0,0.0,0.0);
	triangle.v1 = vec3(0.0,0.0,-4.0);
	triangle.v2 = vec3(1.0,0.0,0.0);
	
	Triangle triangle2;
	triangle2.v0 = vec3(-0.4,0.6,-0.8);
	triangle2.v1 = vec3(0.0,0.1,-1.4);
	triangle2.v2 = vec3(0.4,0.6,-0.8);
	
	for (int i = 0; i < 4; i++) {
		someTest();
	}
	
	//  triangle ray intersection test with back face culling
	float inter0 = triangle_intersection(triangle.v0,triangle.v1,triangle.v2,ro,rd);
	float inter1 = triangle_intersection(triangle2.v0,triangle2.v1,triangle2.v2,ro,rd);
	
	
	float dist;
	dist = min(inter0,inter1);
	
	if (dist < MAX_DISTANCE) {
		// There was a collision
		
		// Point of collision
		vec3 pos = ro + dist * rd;
		// Normal
		vec3 nor = vec3(0.0,0.0,1.0);
		
		// See if lit by point light
		float lightMax = 2.0;
		float li = 1.0 - clamp(length(pointLight - pos),0.0,lightMax) / lightMax;
		
		// check for objects in front of light
		if (li > 0.0) {
			float inter1b = triangle_intersection(triangle2.v0,triangle2.v1,triangle2.v2,pos,normalize(pointLight-pos));
			if (inter1b < MAX_DISTANCE && inter1b < length(pointLight - pos)) {
				li = 0.0;
			}
		}
		
		
		col = vec3(li);
	}
	
	
	
	return col;
}



float iSphere(in vec3 ro, in vec3 rd, in vec4 sph) {
	
	vec3 oc = ro - sph.xyz;
	float b = 2.0*dot(oc,rd);
	float c = dot(oc,oc) - sph.w*sph.w;
	float h = b*b - 4.0*c;
	if (h < 0.0) return -1.0;
	float t = (-b - sqrt(h))/2.0;
	return t;
}

vec3 nSphere(in vec3 pos, in vec4 sph) {
	return (pos-sph.xyz);
}

float iPlane(in vec3 ro, in vec3 rd) {
	return -ro.y/rd.y;
}

vec3 nPlane(in vec3 pos) {
	return vec3(0.0,1.0,0.0);
}

vec4 sph1 = vec4(0.0,1.2,0.0,1.0);

float intersect(in vec3 ro, in vec3 rd, out float resT) {
	
	resT = 1000.0;
	float id = -1.0;
	
	float tsph = iSphere(ro,rd,sph1);
	float tpla = iPlane(ro,rd);
	if (tsph > 0.0) {
		id = 1.0;
		resT = tsph;
	}
	if (tpla > 0.0 && tpla < resT) {
		id = 2.0;
		resT = tpla;
	}
	
	
	return id;
}


void main(void) {
	
	vec3 light = normalize( vec3(0.57703));
	
	// Pixel coordinates 0 - 1
	vec2 uv = gl_FragCoord.xy/resolution;
	
	
	// generate a ray
	vec3 ro = vec3(0.0,1.0,3.0);
	vec3 rd = normalize(vec3(-1.0 + 2.0*uv, -1.0));
	
	
	// Intersect ray with scene
	float t;
	float id = intersect(ro,rd,t);
	
	// Default to black
	vec3 col = vec3(0.0);
	if (id > 0.5 && id < 1.5) {
		// Intersection with sphere
		vec3 pos = ro + t*rd;
		vec3 nor = normalize(nSphere(pos,sph1));
		
		// Do ray from sphere intersection point
		// in direction of surface normal
		float b;
		float idb = intersect(pos,nor,b);
		
		float ac = 0.0;
		if (idb > 1.5) {
			vec3 intePos = pos + b*nor;
			float distan = length(intePos-pos);
			ac = 0.5 - clamp(distan,0.0,2.0)/2.0;
		}
		
		
		float dif = clamp(dot(nor, light), 0.0, 1.0);
		float amb = 0.5 + 0.5*nor.y;
		col = vec3(1.0,1.0-ac,1.0-ac);//*dif + amb*vec3(0.5,0.6,0.7);
	}
	else if (id > 1.5) {
		// Intersection with plane
		vec3 pos = ro + t*rd;
		vec3 nor = nPlane(pos);
		float dif = clamp( dot(nor,light), 0.0, 1.0);
		float amb = 0.2;
		col = vec3(1.0, 0.0, 0.0);//*dif + amb*vec3(0.5,0.6,0.2);
	}
	
	
	
	gl_FragColor = vec4(colourOfPixel(uv),1.0);
	
	
}