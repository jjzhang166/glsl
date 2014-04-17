//building off paulo falcao's raymarch framework -alice
//--added random building size -h3r3 ;)
#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;
//Simple raymarching sandbox with camera

//Raymarching Distance Fields
//About http://www.iquilezles.org/www/articles/raymarchingdf/raymarchingdf.htm
//Also known as Sphere Tracing
//Original seen here: http://twitter.com/#!/paulofalcao/statuses/134807547860353024

//Declare functions
vec2 ObjUnion(in vec2 d1,in vec2 d2);
vec2 floorPlane(in vec3 p);
vec3 color_checkers(in vec3 p);
vec2 roundBox(in vec3 p);
vec2 sdBox( vec3 p, vec3 b );
vec3 color_white(in vec3 p);
vec2 distanceField(in vec3 p);
vec2 infiniteBuildingsShort(in vec3 p);
vec2 simpleBuilding (vec3 p, vec3 b );
vec4 applyFog (in vec4 currColor, in vec3 ray);
float maxcomp(in vec3 p );
vec2 infiniteBuildingsTall(in vec3 p);
vec2 infiniteBuildings(in vec3 p);
float sdCross( in vec3 p );
vec2 sidewalk(vec3 p);
vec2 tallBuilding (vec3 p, vec3 b );



#define EPS 0.01
#define INF 100000.0

#define PHONG_SHADING 0
#define RAYMARCH_SHADING 1
#define TEST_SHADING 2

#define SPINNING_CAMERA 0
#define MOUSE_CAMERA 1
#define PAN_CAMERA 2
#define STILL_CAMERA 3
#define AUTOPAN_CAMERA 4

// mode selection
const int SHADING_MODE = TEST_SHADING; 
const int CAMERA_MODE = AUTOPAN_CAMERA; 
vec3 E;

// some simple colors
const vec3 COLOR_GREY = vec3(0.5,0.5,0.5);
const vec3 COLOR_DARKGREY = vec3(0.74, 0.72, 0.71);
const vec3 COLOR_WHITE = vec3(1.0,1.0,1.0);

//============================== UTILS ====================================//
vec2 distanceField(in vec3 p){
	return ObjUnion(floorPlane(p),infiniteBuildings(p)); // infinite boxes
	
	//vec2 test = ObjUnion(infiniteBuildingsShort(p),infiniteBuildingsTall(p)); //multiple mod patterns
	//return ObjUnion(floorPlane(p),test);
}

vec2 ObjUnion(in vec2 d1,in vec2 d2){
	if (d1.x<d2.x)
	return d1;
	else
	return d2;
}

// http://www.ozone3d.net/blogs/lab/20110427/glsl-random-generator/
float rand(vec2 n)
{
	return 0.5 + 0.5 *
	fract(sin(dot(n.xy, vec2(12.9898, 78.233)))* 43758.5453);
}

// from IQ
float maxcomp(in vec3 p ) { return max(p.x,max(p.y,p.z));}



// =============================== OBJECTS =======================================//
// CREDIT: http://www.iquilezles.org/www/articles/distfunctions/distfunctions.htm //

//floorPlane (color is determined by y-component, ie 0.0)
vec2 floorPlane(in vec3 p){
	return vec2(p.y+2.0,0);
}

// ROUNDBOX (try other objects )
//(color is determined by y-component, ie 1.0)
vec2 roundBox(in vec3 p){
	return vec2(length(max(abs(p)-vec3(1,1,1),0.0))-0.25,1);
}

// SIGNED BOX
vec2 sdBox( vec3 p, vec3 b ){
  vec3  di = abs(p) - b;
  float mc = maxcomp(di);
  return vec2(min(mc,length(max(di,0.0))), 1);
}

// INFINITE BUILDINGS SHORT
vec2 infiniteBuildingsShort(in vec3 p){
	vec3 c = vec3(10,10,10); // how close cubes are to each other
	vec3 f = vec3(7,10,7);
	
	vec3 q = p;
	//repetition in x and z direction
	q.x = mod(p.x,c.x)-0.5*c.x;
	q.x = mod(q.x,f.x)-0.5*f.x;
	
	q.z = mod(p.z,c.z)-0.5*c.z;
	q.z = mod(q.z,f.z)-0.5*f.z;
	
	//building height
	vec3 b = vec3(1.0, 3.0, 1.0);
	return sdBox(q,b);	
}

// INFINITE BUILDINGS TALL
vec2 infiniteBuildingsTall(in vec3 p){
	vec3 c = vec3(11,10,11); // how close cubes are to each other
	
	vec3 q = p;
	//repetition in x and z direction
	q.x = mod(p.x,c.x)-0.8*c.x;	
	q.z = mod(p.z,c.z)-0.5*c.z;
	
	//building height
	vec3 b = vec3(1.0, 8.0, 1.0);
	return sdBox(q,b);
}

// INFINITE BUILDINGS RANDOM (CREDIT: H3R3)
vec2 infiniteBuildings(in vec3 p){
	
	vec3 c = vec3(5,5,5); // how close cubes are to each other
	
	vec3 q = p;
	//repetition in x and z direction
	q.x = mod(p.x,c.x)-0.5*c.x;
	q.z = mod(p.z,c.z)-0.5*c.z;
	
	vec2 pos = vec2(ceil(p.x/c.x), ceil(p.z/c.z));
	
	float height = rand(pos)*5.0;//* 10.0 - 4.0;
	float width1 = rand(pos + 100.0) + 0.5;
	float width2 = rand(pos + 1500.0) + 0.5;
	
	//building height
	//vec3 k = vec3(1,height,1);
	vec3 k = vec3(max(0.0, width1), max(0.0, height), max(0.0, width2));
	//return simpleBuilding(q,k);	
	return simpleBuilding(q,k);
}


// SIMPLE BUILDING (white)
vec2 simpleBuilding (vec3 p, vec3 b ){
	float body = sdBox(p,b).x;
	
	vec3 q = p;
	vec3 c = vec3(0.5); //0.5

	q = mod(p,c)-0.5*c;
	
	float cr = sdCross(q*3.0)/3.0;
	body = max( body, -cr );
	
	float top = sdBox(p-vec3(0,b.y,0),vec3(1.0, b.y/25.0, 1.0)).x;
	float inside = sdBox(p,vec3(b.x*0.9, b.y, b.z*0.9)).x;
	body = min(inside,min(body,top));
	
  return vec2(body,1);
}

//TALL BUILDING (WHITE)
vec2 tallBuilding (vec3 p, vec3 b ){
	float body = sdBox(p,b).x;
	
	vec3 q = p;
	vec3 c = vec3(0.5);
	q = mod(p,c)-0.5*c;
	float vert_bars = sdBox(q,vec3(0.1,INF,0.1)).x;
	body = max(body, -vert_bars);
	
	//dividng ledge
	const float ledgeheight = 0.2;
	float ledge = sdBox(p-vec3(0,b.y,0),vec3(b.x,ledgeheight,b.z)).x;
	body = min(body,ledge);
	
	//2nd portion
	float body2 = sdBox(p-vec3(0,b.y+ledgeheight,0),b*vec3(0.8,0.2,0.8)).x;
	body = min(body,body2);
	
	//3rd portion
	float body3 = sdBox(p-vec3(0,b.y+ledgeheight+b.y*0.2, 0), b*vec3(0.6,0.2,0.6)).x;
	body = min(body3, body);
			    
	
	return vec2(body,1);
}

// SD_CROSS (modified from IQ's original)
float sdCross( in vec3 p ){
	const float w = 0.4;
  float da = sdBox(p.xyz,vec3(INF,w,w)).x;
  float db = sdBox(p.yzx,vec3(w,INF,w)).x;
  float dc = sdBox(p.zxy,vec3(w,w,INF)).x;
  return min(da,db);
}


//looks bad, fix later
vec2 sidewalk(vec3 p){
	vec3 c = vec3(5);
	vec3 q = p;
	
	//repeat in x and z directin
	q.x = mod(p.x,c.x)-0.5*c.x;
	q.z = mod(p.z,c.z)-0.5*c.z;
	vec2 pos = vec2(ceil(p.x/c.x), ceil(p.z/c.z));
	
	float width1 = rand(pos + 100.0) + 0.5;
	float width2 = rand(pos + 1500.0) + 0.5;
	
	return sdBox(p, vec3(max(0.0, width1), 0.2, max(0.0, width2)));
}



// ============COLORS============= //
// Checkerboard Color
vec3 color_checkers(in vec3 p){
	if (fract(p.x*.5)>.5)
	if (fract(p.z*.5)>.5)
	return COLOR_GREY;
	else
	return vec3(1,1,1);
	else
	if (fract(p.z*.5)>.5)
	return vec3(1,1,1);
	else
	return COLOR_GREY;
}

// ==================== RAY MARCH =============================//
void main(void){
	//Camera animation
	vec3 U=vec3(0,1,0);//Camera Up Vector
	vec3 viewDest=vec3(0,0,0); //Change camere view vector here
	//vec3 E; //moved to global space
	if (CAMERA_MODE == SPINNING_CAMERA)
	E=vec3(-sin(time/10.0)*10.0,5,cos(time/10.0)*10.0); //spinning scene
	else if(CAMERA_MODE == MOUSE_CAMERA){
		float spin = mouse.x * 8.0; //time * 0.1 + mouse.x * 8.0;
		E=vec3(-sin(spin)*10.0, 10.0 * mouse.y, cos(spin)*10.0);//Change camera path position here
	}
	else if(CAMERA_MODE == PAN_CAMERA){
		E=vec3(-sin(1.0)*10.0,7,cos(1.0)*10.0);
		vec3 moveCamDir = normalize(vec3(E.x,0.0,E.y));
		float mouse_val = mouse.y-0.5;
		E+=moveCamDir*time*(mouse_val>0.0?mouse_val:0.0);
	}
	else if(CAMERA_MODE == STILL_CAMERA){
		E=vec3(-sin(1.0)*10.0,7,cos(1.0)*10.0);//Change camera path position here
	}
	else if (CAMERA_MODE == AUTOPAN_CAMERA){
		E=vec3(-sin(1.0)*10.0,7,cos(1.0)*10.0);
		vec3 moveCamDir = normalize(vec3(E.x,0.0,E.y));
		E+=moveCamDir*time;
	}
	
	
	//Camera setup
	vec3 C=normalize(viewDest-E);
	vec3 A=cross(C, U);
	vec3 B=cross(A, C);
	vec3 M=(E+C);

	vec2 vPos=2.0*gl_FragCoord.xy/resolution.xy - 1.0; // = (2*Sx-1) where Sx = x in screen space (between 0 and 1)
	vec3 P=M + vPos.x*A*resolution.x/resolution.y + vPos.y*B; //normalize resolution in either x or y direction (ie resolution.x/resolution.y)
	vec3 rayDir=normalize(P-E); //normalized direction vector from Eye to point on screen
	
	//Colors
	const vec4 skyColor = vec4(0.7, 0.8, 1.0, 1.0);
	const vec4 sunColor = vec4 (1.0, 0.9, 0.7, 1.0);
	
	//Raymarching
	const vec3 e=vec3(0.1,0,0);
	const float MAX_DEPTH=170.0; //Max depth use 500
	const int MAX_STEPS = 100; // max number of steps use 150
	const float MIN_DIST = 0.01;

	vec2 dist=vec2(0.0,0.0);
	float totalDist=0.0;
	vec3 c,p,n; //c=color (used in PHONG and RAYMARCH modes), p=ray position, n=normal at any point on the surface

	int steps = 0;
	for(int i=0;i<MAX_STEPS;i++){
		steps++;
		totalDist+=dist.x;
		p=E+rayDir*totalDist; // p = eye + total_t*rayDir
		dist=distanceField(p);
		if (abs(dist.x)<MIN_DIST) break; // break when p gets sufficiently close to object or exceeds max dist
	}

	vec4 finalColor = skyColor;
	
	if (totalDist<MAX_DEPTH){
		// check which color to use via the y-component
		if (dist.y==0.0) // floorPlane color
		c=color_checkers(p);
		else if(dist.y==1.0) // building color
		c=COLOR_WHITE;
		
		if(SHADING_MODE==PHONG_SHADING){
			// compute normal at this point on the surface using a gradient vector
			n=normalize(
			vec3(
			dist.x-distanceField(p-e.xyy).x,
			dist.x-distanceField(p-e.yxy).x,
			dist.x-distanceField(p-e.yyx).x));
			
			//e.xyy is equal to (0.001,0.0,0.0) 
			//e.yxy is equal to (0.0,0.001,0.0)
			//e.xxy is equal to (0.0,0.0,0.001)

			//simple phong LightPosition=CameraPosition	   
			float b=dot(n,normalize(E-p));
			finalColor=vec4((b*c+pow(b,8.0))*(1.0-totalDist*.01),1.0);
		}
		else if (SHADING_MODE==RAYMARCH_SHADING){
			//Shading based on raymarched distance
			float v = 1.0-float(steps)/float(MAX_STEPS);
			float R=v*c.r, G=v*c.g, B=v*c.b;
			finalColor=vec4(R,G,B,1.0);
		}
		else if (SHADING_MODE==TEST_SHADING){
			vec3 sunDir = vec3(normalize(viewDest-E)); //sun comes from the camera
			
			vec3 N = normalize(vec3(
			distanceField(p).x-distanceField(p-e.xyy).x,
			distanceField(p).x-distanceField(p-e.yxy).x,
			distanceField(p).x-distanceField(p-e.yyx).x)); //normal at point
			
			vec3 L = sunDir;
			vec3 V = normalize(E-p);
			
			// color info is stored in y component
			if (dist.y==0.0) // floorPlane color
				finalColor=vec4(color_checkers(p),1.0);
			if(dist.y==1.0) // building color
				finalColor=vec4(COLOR_GREY,1.0);
			
			//calculate lighting: diffuse + sunlight
			float diffuseTerm = clamp(dot(V,N), 0.0, 1.0);
			finalColor = mix(finalColor, sunColor, diffuseTerm);			
			
		}
	}
	//apply fog
	vec3 r = p-E;
	finalColor = applyFog(finalColor, r);
	gl_FragColor = finalColor;
}


// Fog (credit: http://www.mazapan.se/news/2010/07/15/gpu-ray-marching-with-distance-fields/)
vec4 applyFog (in vec4 currColor, in vec3 ray){
	float rayLength = length(ray);
	vec3 nRay = ray/rayLength;
	
	float fogAmount = 1.0-exp(-rayLength * 0.02); //0.008
	float sunAmount = 0.0;//pow( max( dot (nRay, sunDir), 0.0), 8.0);
	
	vec4 fogColor = mix(vec4(0.5,0.6,0.7,1.0), vec4(1.0,0.9,0.7,1.0), sunAmount);
	return mix(currColor, fogColor, fogAmount);
}
