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
vec2 obj_udBox( vec3 p, vec3 b );
vec2 obj_sdBox( vec3 p, vec3 b );
vec3 color_white(in vec3 p);
vec2 distanceField(in vec3 p);
vec2 obj_manyBoxes(in vec3 p);
vec2 obj_simpleBuilding(in vec3 p, in float height);
vec2 obj_testBuildings(in vec3 p);
vec4 applyFog (in vec4 currColor, in vec3 ray);
float AOAtPoint(vec3 p, vec3 n);
float SSSAtPoint(vec3 p,vec3 rayDir);
float maxcomp(in vec3 p );

#define EPS 0.01

#define PHONG_SHADING 0
#define RAYMARCH_SHADING 1
#define TEST_SHADING 2

#define SPINNING_CAMERA 0
#define SPINNING_CAMERA_W_MOUSE 1
#define TEST_CAMERA 2

const int SHADING_MODE = PHONG_SHADING; 
const int CAMERA_MODE = SPINNING_CAMERA;





//Util Start
vec2 ObjUnion(in vec2 d1,in vec2 d2){
	if (d1.x<d2.x)
	return d1;
	else
	return d2;
}

vec2 distanceField(in vec3 p){
	return ObjUnion(obj_floor(p),obj_manyBoxes(p));
	//return ObjUnion(obj_floor(p),obj_simpleBuilding(p,1.0));
}

// http://www.ozone3d.net/blogs/lab/20110427/glsl-random-generator/
float rand(vec2 n)
{
	return 0.5 + 0.5 *
	fract(sin(dot(n.xy, vec2(12.9898, 78.233)))* 43758.5453);
}

// from IQ
float maxcomp(in vec3 p ) { return max(p.x,max(p.y,p.z));}


//Util End



//Scene Start
// ===============================OBJECTS======================================== //
// CREDIT: http://www.iquilezles.org/www/articles/distfunctions/distfunctions.htm //

//FLOOR (color is determined by y-component, ie 0.0)
vec2 obj_floor(in vec3 p){
	return vec2(p.y+2.0,0);
}

// ROUNDOX (try other objects )
//(color is determined by y-component, ie 1.0)
vec2 obj_roundBox(in vec3 p){
	return vec2(length(max(abs(p)-vec3(1,1,1),0.0))-0.25,1);
}

// UNSIGNED BOX
vec2 obj_udBox( vec3 p, vec3 b ){
  return vec2(length(max(abs(p)-b,0.0)),1);
}

//SIGNED BOX
vec2 obj_sdBox( vec3 p, vec3 b ){
  vec3  di = abs(p) - b;
  float mc = maxcomp(di);
  return vec2(min(mc,length(max(di,0.0))), 1);
}

// INFINITE BOXES
vec2 obj_manyBoxes(in vec3 p){
	vec3 offset = vec3(0,3,0); //makes cubes touch the ground
	vec3 c = vec3(5,10,5); // how close cubes are to each other
	vec3 q = p;
	//vec3 q = mod(p-offset,c)-0.5*c;
	q.x = mod(p.x-offset.x,c.x)-0.5*c.x;
	q.z = mod(p.z-offset.z,c.z)-0.5*c.z;
	
	return obj_sdBox(q,vec3(1.0,2.0,1.0));	
}

// SIMPLE BUILDING (white)
vec2 obj_simpleBuilding(in vec3 p, in float height){
	vec3 offset = vec3(0.0, (-height), 0.0);
	return vec2(length(max(abs(p+offset)-vec3(1,height,1), 0.0)), 1);
}


// TEST BUILDINGS (white)
vec2 obj_testBuildings(in vec3 p){
	float min = 1000000.0;
	vec2 building;
	for(int j = 1; j < 4; j++){
		for(int i = 1; i < 4; i++){
			building = obj_simpleBuilding(p+vec3(i*3,0.0,j*3)+vec3(-5,0,-5), rand(vec2(i,j))*3.0);
			if(building.x < min)
			min = building.x;
		}
	}
	return vec2(min,1);
}


// ============COLORS============= //
// Checkerboard Color
vec3 color_checkers(in vec3 p){
	if (fract(p.x*.5)>.5)
	if (fract(p.z*.5)>.5)
	return vec3(0,0,1);
	else
	return vec3(1,0,0);
	else
	if (fract(p.z*.5)>.5)
	return vec3(1,1,0);
	else
	return vec3(0,1,1);
}

// White color
vec3 color_white(in vec3 p){
	return vec3(0.9,0.8,1.0);
}

//Scene End


void main(void){
	//Camera animation
	vec3 U=vec3(0,1,0);//Camera Up Vector
	vec3 viewDest=vec3(0,0,0); //Change camere view vector here
	vec3 E;
	if (CAMERA_MODE == SPINNING_CAMERA)
	E=vec3(-sin(time/10.0)*10.0,5,cos(time/10.0)*10.0); //spinning scene
	else if(CAMERA_MODE == SPINNING_CAMERA_W_MOUSE){
		float spin = mouse.x * 8.0; //time * 0.1 + mouse.x * 8.0;
		E=vec3(-sin(spin)*4.0, 8.0 * mouse.y, cos(spin)*4.0);//Change camera path position here
	}
	else if(CAMERA_MODE == TEST_CAMERA){
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
	const vec4 vignetteColor = vec4(0.74, 0.42, 0.71, 1.0);
	const vec4 floorColor = vec4(0.74, 0.72, 0.71, 1.0);
	const vec4 boxColor = vec4(0.5,0.5,0.5,1);
	const vec4 boxSSSColor = vec4(1, 0.2,0.8,1);
	
	//Raymarching
	const vec3 e=vec3(0.1,0,0);
	const float MAX_DEPTH=500.0; //Max depth use 500
	const int MAX_STEPS = 150; // max number of steps use 150
	const float MIN_DIST = 0.01;

	vec2 dist=vec2(0.0,0.0);
	float totalDist=0.0;
	vec3 c,p,n; //c=color, p=ray position, n=normal at any point on the surface

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
		c=color_white(p);
		
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
			
			// TODO: USE A COLOR LOOKUP FUNCTION LATER
			if (dist.y==0.0) // floor color
				finalColor=floorColor;
			if(dist.y==1.0) // building color
				finalColor=boxColor;
			
			//calculate lighting: diffuse + sunlight
			float diffuseTerm = clamp(dot(V,N), 0.0, 1.0);
			finalColor = mix(finalColor, sunColor, diffuseTerm);			
			
		}
	}
	//apply fog
	vec3 r = p-E;
	//finalColor = applyFog(finalColor, r);
	gl_FragColor = finalColor;
}


// Fog
vec4 applyFog (in vec4 currColor, in vec3 ray){
	float rayLength = length(ray);
	vec3 nRay = ray/rayLength;
	
	float fogAmount = 1.0-exp(-rayLength * 0.008);
	float sunAmount = 0.0;//pow( max( dot (nRay, sunDir), 0.0), 8.0);
	
	vec4 fogColor = mix(vec4(0.5,0.6,0.7,1.0), vec4(1.0,0.9,0.7,1.0), sunAmount);
	return mix(currColor, fogColor, fogAmount);
}
