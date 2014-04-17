//building off paulo falcao's raymarch framework -alice

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
vec2 obj_floor(in vec3 p);
vec3 color_checkers(in vec3 p);
vec2 obj_roundBox(in vec3 p);
vec2 obj_sdBox( vec3 p, vec3 b );
vec3 color_white(in vec3 p);
vec2 distanceField(in vec3 p);
vec2 obj_infiniteBuildings(in vec3 p);
vec2 obj_simpleBuilding(in vec3 p, in float height);
vec4 applyFog (in vec4 currColor, in vec3 ray);
float maxcomp(in vec3 p );
vec2 obj_clusterBuildings(in vec3 p);
vec2 obj_infiniteBuildings2(in vec3 p);



#define EPS 0.01

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
const vec3 COLOR_GREY = vec3(0.1,0.1,0.7);
const vec3 COLOR_DARKGREY = vec3(0.99, 0.2, 0.1);
const vec3 COLOR_WHITE = vec3(0.0,1.0,0.0);

//============================== UTILS ====================================//
vec2 distanceField(in vec3 p){
	//return ObjUnion(obj_floor(p), obj_simpleBuilding(p, 2.0)); //simple building
	//return ObjUnion(obj_floor(p),obj_infiniteBuildings(p)); // infinite boxes
	//return ObjUnion(obj_floor(p), obj_clusterBuildings(p)); //building cluster
	
	vec2 test = ObjUnion(obj_infiniteBuildings(p),obj_infiniteBuildings2(p));
	return ObjUnion(obj_floor(p),test);
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

//FLOOR (color is determined by y-component, ie 0.0)
vec2 obj_floor(in vec3 p){
	return vec2(p.y+2.0,0);
}

// ROUNDBOX (try other objects )
//(color is determined by y-component, ie 1.0)
vec2 obj_roundBox(in vec3 p){
	return vec2(length(max(abs(p)-vec3(1,1,1),0.0))-0.25,1);
}

//SIGNED BOX
vec2 obj_sdBox( vec3 p, vec3 b ){
  vec3  di = abs(p) - b;
  float mc = maxcomp(di);
  return vec2(min(mc,length(max(di,0.0))), 1);
}

// INFINITE BUILDINGS
vec2 obj_infiniteBuildings(in vec3 p){
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
	return obj_sdBox(q,b);	
}

// INFINITE BUILDINGS2
vec2 obj_infiniteBuildings2(in vec3 p){
	vec3 c = vec3(11,10,11); // how close cubes are to each other
	
	vec3 q = p;
	//repetition in x and z direction
	q.x = mod(p.x,c.x)-0.8*c.x;	
	q.z = mod(p.z,c.z)-0.5*c.z;
	
	//building height
	vec3 b = vec3(1.0, 8.0, 1.0);
	return obj_sdBox(q,b);
}


// SIMPLE BUILDING (white)
vec2 obj_simpleBuilding(vec3 p, in float height){
	vec3 b = vec3(1,height,1);
	vec3  di = abs(p) - b;
	float mc = maxcomp(di);
	return vec2(min(mc,length(max(di,0.0))), 1);
}


// ClUSTER OF BUILDINGS (white)
vec2 obj_clusterBuildings(in vec3 p){
	float min = 1000000.0;
	vec2 building;
	
	const int start_i = 0;
	const int start_j = 0;
	const int num = 4;
	const int spacing = 4;
	const vec3 centerOffset = vec3(num/2*spacing, 0, num/2*spacing); // centers the building cluster

	
	for(int i = start_i; i < num; i++){
		for(int j = start_j; j < num; j++){
			vec3 building_offset= vec3(i*spacing,0,j*spacing);  // space out each building
			
			building = obj_simpleBuilding(p+building_offset-centerOffset, rand(vec2(i,j))*5.0);
			
			if(building.x < min)
				min = building.x;
		}
	}
	return vec2(min,1.0);
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
		if (dist.y==0.0) // floor color
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
			if (dist.y==0.0) // floor color
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
