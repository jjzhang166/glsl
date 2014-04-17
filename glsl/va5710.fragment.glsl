#ifdef GL_ES
precision highp float;
#endif

// I am trying to understand raymarching and decided to clean up a simple example I found and gave it proper names for all the variables
// Hope this helps someone better understand how this works.
// countfrolic@gmail.com

// Tried to make a wintry tree - Kabuto


#define PI 3.14159
const float sin45deg = 0.70710678118654752440084436210485;

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;
	
struct Camera											// A camera struct that holds all relevant camera parameters
{
	vec3 position;
	vec3 lookAt;
	vec3 rayDir;
	vec3 forward, up, left;
};

// elements library by logos7(a.t.)o2.pl
// see: http://logos7.pl/Anupadaka/index.html
// http://logos7.pl/Anupadaka/sde_space_operations.php
// http://logos7.pl/Anupadaka/sde_primitives3D.php
// I want to create the biggest elements library - you can help me and send your own things
// you will be credited
	
vec3 sopPolarRepeatY(vec3 P, float n)
{
	float r = length(P.xz);
	float a = atan(P.z, P.x);
	float c = 3.14159265358979 / n;

	a = mod(a, 2.0 * c) - c;

	P.x = r * cos(a);
	P.z = r * sin(a);

	return P;
}

// Optimized case for 4 repetitions
vec3 sopPolarRepeatY4(vec3 P)
{
	P.xz = vec2(P.x+P.z,P.z-P.x)*sin45deg;
	P.xz = abs(P.x) > abs(P.z) ? P.xz*sign(P.x) : vec2(P.z,-P.x)*sign(P.z);
	return P;
}

vec3 sopRotateZ(vec3 P, float a)
{
	float c = cos(a);
	float s = sin(a);

	return vec3(c * P.x - s * P.y, s * P.x + c * P.y, P.z);
}

float sdeCylinderY(vec3 P, vec3 C, float h, float r)
{
	P -= C;

	return max(abs(P.y) - 0.5 * h, length(P.xz) - r);
}

float GetDistanceToScene( vec3 P)
{
	P.xz = (fract(P.xz*.3+.5)-.5)/.3;
	float d = min(sdeCylinderY(P, vec3(0.0), 1.0, 0.085), min(P.y,6.-P.y)); // ground & sky planes added
	float s;
	vec3 O = P;
	float f = 1.; // remember the scaling applied to space so far

	for (int i = 0; i < 5; i++)
	{
		O = 1.4 * O;
		f = 1.4 * f;
		O = sopPolarRepeatY4(O);

		O = sopRotateZ(O, 0.842);

		O.x -= -0.515;
		O.y -= 1.0;

		d = min(d, sdeCylinderY(O, vec3(0.0), 1.0, 0.085)/f); // Tweak: /f added. (If you scale space you should scale distances as well. This works much better than the previously used approximation.)
	}

	return d;
}

float traceLight(vec3 from, vec3 to, float tolerance) {
	float len = distance(from,to);
	vec3 dir = (to-from)/len;
	
  	const float MIN_DISTANCE = 0.1;								// Distance to scene that we will count as a hit
	const int MAX_STEPS = 50;								// Maxmimum amount of ray marching steps before counting the ray as a miss
	
	float distanceFromCamera = 0.0;								// The ray starts at the camera, so 0
	
  	vec3 raymarchPosition = from;									// Variable holding the current position along the camera ray
	float distanceToScene = GetDistanceToScene(raymarchPosition);
  	
  	for(int i=0;i<MAX_STEPS;i++){
    		if (distanceToScene< MIN_DISTANCE || distanceFromCamera>len-tolerance) break;	// Exit if we hit something, or if the ray goes past MAX_DEPTH
    	
		distanceFromCamera += distanceToScene;						// If we didn't exit, move away from the camera...
    		raymarchPosition = from+dir*distanceFromCamera;			// Calculate new position along the camera ray
		distanceToScene = GetDistanceToScene(raymarchPosition);				// Check how far the new position is away from the scene
  	}
	return step(len-tolerance, distanceFromCamera);
}

float traceLight2(vec3 from, vec3 to) {
	float len = distance(from,to);
	vec3 dir = (to-from)/len;
	
  	const float MIN_DISTANCE = 0.1;								// Distance to scene that we will count as a hit
	const int MAX_STEPS = 40;								// Maxmimum amount of ray marching steps before counting the ray as a miss
	
	float distanceFromCamera = 0.0;								// The ray starts at the camera, so 0
	
  	vec3 raymarchPosition = from;									// Variable holding the current position along the camera ray
	float distanceToScene = GetDistanceToScene(raymarchPosition);
  	
  	for(int i=0;i<MAX_STEPS;i++){
    		if (distanceToScene< MIN_DISTANCE || distanceFromCamera>len) break;	// Exit if we hit something, or if the ray goes past MAX_DEPTH
    	
		distanceFromCamera += distanceToScene;						// If we didn't exit, move away from the camera...
    		raymarchPosition = from+dir*distanceFromCamera;			// Calculate new position along the camera ray
		distanceToScene = GetDistanceToScene(raymarchPosition);				// Check how far the new position is away from the scene
  	}
	return step(len, distanceFromCamera);
}

void main(void){
	
  // General parameter setup
	vec2 vPos = 2.0*gl_FragCoord.xy/resolution.xy - 1.0; 					// map vPos to -1..1
	float t = time*0.5;									// time value, used to animate stuff
	float screenAspectRatio = resolution.x/resolution.y;					// the aspect ratio of the screen (e.g. 16:9)
	vec3 finalColor = vec3(0.1);								// The background color, dark gray in this case
	
   //Camera setup
	Camera cam;										// Make a struct holding all camera parameters
  	cam.lookAt = vec3(0,1,0);								// The point the camera is looking at
	cam.position = vec3(mouse.x*8.1-4.1, 3.15, mouse.y*8.1-4.1);						// The position of the camera
	cam.up = vec3(0,1,0);									// The up vector, change to make the camera roll, in world space
  	cam.forward = normalize(cam.lookAt-cam.position);					// The camera forward vector, pointing directly at the lookat point
  	cam.left = cross(cam.forward, cam.up);							// The left vector, which is perpendicular to both forward and up
 	cam.up = cross(cam.left, cam.forward);							// The recalculated up vector, in camera space
 
	vec3 screenOrigin = (cam.position+cam.forward); 					// Position in 3d space of the center of the screen
	vec3 screenHit = screenOrigin + vPos.x*cam.left*screenAspectRatio + vPos.y*cam.up; 	// Position in 3d space where the camera ray intersects the screen
  
	cam.rayDir = normalize(screenHit-cam.position);						// The direction of the current camera ray
	
  //Light source
	vec3 lightSource =  vec3(sin(t)*4.,2.9,cos(t)*4.);

  //Raymarching
  	const float MIN_DISTANCE = 0.1;								// Distance to scene that we will count as a hit
	const float MAX_DEPTH=5.0;								// Distance from camera that we will count as a miss
	const int MAX_STEPS = 50;								// Maxmimum amount of ray marching steps before counting the ray as a miss
	const int FOG_STEPS = 8;
	
  	float distanceToScene = 1.0;								// Initial distance to scene, should be initialized as 1
	float distanceFromCamera = 0.0;								// The ray starts at the camera, so 0
	
  	vec3 raymarchPosition;									// Variable holding the current position along the camera ray
    		raymarchPosition = cam.position+cam.rayDir*distanceFromCamera;			// Calculate new position along the camera ray
		distanceToScene = GetDistanceToScene(raymarchPosition);				// Check how far the new position is away from the scene
  	
  	for(int i=0;i<MAX_STEPS;i++){
    		if (distanceToScene< MIN_DISTANCE || distanceFromCamera>MAX_DEPTH) break;	// Exit if we hit something, or if the ray goes past MAX_DEPTH
    	
		distanceFromCamera += distanceToScene;						// If we didn't exit, move away from the camera...
    		raymarchPosition = cam.position+cam.rayDir*distanceFromCamera;			// Calculate new position along the camera ray
		distanceToScene = GetDistanceToScene(raymarchPosition);				// Check how far the new position is away from the scene
  	}
	
  //Lighting
	
	// Raymarch from light source to raymarch pos (in that direction since it should be slightly faster that way)
	float lightFalloff = dot(lightSource-raymarchPosition,lightSource-raymarchPosition);
	float diffuse = traceLight(lightSource, raymarchPosition,.01)/lightFalloff*1.;

	
	// Take fog samples. These samples are distributed in such a way that each sample catches the same amount of light.
	
	// m = distance to the point closest to the light sorce
	float m = dot(cam.rayDir, lightSource-cam.position);
	
	// d = distance to light source at that point
	float d = length(cam.position-lightSource+m*cam.rayDir);
	
	// a,b = start and end points relative to m
	float a = -m;
	float b = distanceFromCamera-m;
	float aa = atan(a/d);
	float ba = atan(b/d);
	
	// t = total light gathered by fog without shadows
	float to = (ba-aa)/d;
	
	
	float random = fract(sin(time+dot(gl_FragCoord.xy, vec2(.1,.163))) * 47267.4);
	vec3 fog = vec3(0.);
	for(int i = 0;i<FOG_STEPS; i++) {
		// s = test point in interval 0..1
		float s = (random+float(i))/float(FOG_STEPS);
		
		// p = actual sampling point in camera ray
		float p = m+d*tan(s*ba+(1.-s)*aa);
		
		vec3 fogTest = cam.position+cam.rayDir*p;
		fog += traceLight2(lightSource, fogTest)*vec3(i*i,2*i*(FOG_STEPS-1-i),(FOG_STEPS-1-i)*(FOG_STEPS-1-i))/float((FOG_STEPS-1)*(FOG_STEPS-1));
	}
	fog *= to*4./float(FOG_STEPS);
	
	gl_FragColor = vec4(sqrt(fog), 1.0);							// Output final color
}