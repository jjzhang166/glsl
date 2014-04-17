
#ifdef GL_ES
precision highp float;
#endif

// I am trying to understand raymarching and decided to clean up a simple example I found and gave it proper names for all the variables
// Hope this helps someone better understand how this works.
// countfrolic@gmail.com

// Optimized for rendering speed by Kabuto. About 6x faster now.

// Made forest nonregular. Please note that this method is not 100 perc safe and might cause glitches. 
// Just playing around with MAX_STEPS, was trying to have smaller max steps in the middle of a tree and larger at the edges but couldn't make it work.
// -> well, the reason for that is that it'S already optmized quite well and increasing step size further would only make the distance field step too far
// also added flying motion

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

float sdPlane( vec3 p, vec4 n )
{
  // n must be normalized
  return dot(p,n.xyz) + n.w;
}


float GetDistanceToScene2( vec3 P)
{
	float d = sdeCylinderY(P, vec3(0.0), 1.0, 0.045);
	float s;
	vec3 O = P;
	float f = 1.0; // remember the scaling applied to space so far

	for (int i = 0; i < 5; i++)
	{
		O = 1.4 * O;
		f = 1.4 * f;
		O = sopPolarRepeatY4(O);

		O = sopRotateZ(O, 0.842);

		O.x -= -0.515;
		O.y -= 1.0;

		d = min(d, sdeCylinderY(O, vec3(0.0), 1.0, 0.045)/f); // Tweak: /f added. (If you scale space you should scale distances as well. This works much better than the previously used approximation.)
	}

	return d;
}

// returns are more-or-less random value - always the same as long as the input vector is the same, too.
vec2 random(vec2 p) {
	vec2 result = sin(p+.4);
	return fract(result*999.+result.yx*vec2(431.,123.));
}



float GetDistanceToScene(vec3 P)  {
	float gridScale = 3.1;
	// 1. Consider a regular grid. One tree per unit scale.
	P /= gridScale;
	// To make the whole thing look less regular each tree's center gets shifted randomly by up to 1 unit. This, however, also means that we must consider 4 trees at once.
	
	vec2 intPos = floor(P.xz);
	vec3 fractPos = P-vec3(intPos.x,0,intPos.y);
			    
	float dist = 1e9;
	{vec2 tree0 = random(intPos+vec2(0,0));	dist = min(dist,GetDistanceToScene2((fractPos-vec3(tree0.x,0,tree0.y)+vec3(.5,0,.5))*gridScale));}
	{vec2 tree0 = random(intPos+vec2(1,0));	dist = min(dist,GetDistanceToScene2((fractPos-vec3(tree0.x,0,tree0.y)+vec3(-.5,0,.5))*gridScale));}
	{vec2 tree0 = random(intPos+vec2(0,1));	dist = min(dist,GetDistanceToScene2((fractPos-vec3(tree0.x,0,tree0.y)+vec3(.5,0,-.5))*gridScale));}
	{vec2 tree0 = random(intPos+vec2(1,1));	dist = min(dist,GetDistanceToScene2((fractPos-vec3(tree0.x,0,tree0.y)+vec3(-.5,0,-.5))*gridScale));}
	
	float planeDist = sdPlane(P, vec4(0,1,0,0))*gridScale;
	
	return min(dist, planeDist);

	}


void main(void){
	
  // General parameter setup
	vec2 vPos = 2.0*gl_FragCoord.xy/resolution.xy - 1.0; 					// map vPos to -1..1
	float t = time*0.5;									// time value, used to animate stuff
	float screenAspectRatio = resolution.x/resolution.y;					// the aspect ratio of the screen (e.g. 16:9)
	vec3 finalColor = vec3(0.1, 0.1, 0.2);								// The background color, dark gray in this case
	vec3 lightDir = vec3(0., 1., 0.);
   //Camera setup
	Camera cam;										// Make a struct holding all camera parameters
  	
	cam.position = vec3(0., 3.+sin(t), t);						// The position of the camera
	cam.lookAt = cam.position+vec3(0,0,1.);								// The point the camera is looking at
	
	cam.up = vec3(0,1,0);									// The up vector, change to make the camera roll, in world space
  	cam.forward = normalize(cam.lookAt-cam.position);					// The camera forward vector, pointing directly at the lookat point
  	cam.left = cross(cam.forward, cam.up);							// The left vector, which is perpendicular to both forward and up
 	cam.up = cross(cam.left, cam.forward);							// The recalculated up vector, in camera space
 
	vec3 screenOrigin = (cam.position+cam.forward); 					// Position in 3d space of the center of the screen
	vec3 screenHit = screenOrigin + vPos.x*cam.left*screenAspectRatio + vPos.y*cam.up; 	// Position in 3d space where the camera ray intersects the screen
  
	cam.rayDir = normalize(screenHit-cam.position);						// The direction of the current camera ray

  //Raymarching
  	const float MIN_DISTANCE = 0.1;								// Distance to scene that we will count as a hit
	const float MAX_DEPTH=196.0;								// Distance from camera that we will count as a miss
	const int MAX_STEPS = 50;								// Maxmimum amount of ray marching steps before counting the ray as a miss
	
	float distanceFromCamera = 0.0;								// The ray starts at the camera, so 0
	
    	vec3 raymarchPosition = cam.position;			// Calculate new position along the camera ray
	float distanceToScene = GetDistanceToScene(raymarchPosition);				// Check how far the new position is away from the scene
	vec3 rayDir = cam.rayDir; // actual ray
	vec3 color = vec3(0);
	vec3 alpha = vec3(1);
  	
  	for(int i=0;i<MAX_STEPS;i++){
    		if (abs(distanceToScene)< MIN_DISTANCE || distanceFromCamera>MAX_DEPTH) break;	// Exit if we hit something, or if the ray goes past MAX_DEPTH
		if (raymarchPosition.y < .1) { rayDir.y = abs(rayDir.y); alpha = vec3(.1,.4,.7);}
    	
		distanceFromCamera += distanceToScene;						// If we didn't exit, move away from the camera...
    		raymarchPosition += rayDir*distanceToScene;			// Calculate new position along the camera ray
		distanceToScene = GetDistanceToScene(raymarchPosition);				// Check how far the new position is away from the scene
  	}
	
  //Lighting
  
	vec3 diffuseColor,normal;
	const vec3 e=vec3(0.02,0,0);								// Epsilon value, used to calculate the hit normal
	
  	if (distanceFromCamera<MAX_DEPTH){							// If this is true, it means we hit something
    		float c = clamp(raymarchPosition.y, 0., 1.0);
		diffuseColor = vec3(0.5, 0.8, 0.2)*c/(distanceFromCamera*0.4);						// Set diffuse color for cube to red
    		normal=normalize(								// Calculate normal... somehow :)
      			vec3(distanceToScene-GetDistanceToScene(raymarchPosition-e.xyy),
           		distanceToScene-GetDistanceToScene(raymarchPosition-e.yxy),
           		distanceToScene-GetDistanceToScene(raymarchPosition-e.yyx)));
    		
		float lambert = pow(dot(normal, lightDir)+1.9,3.0)*exp(-10.*distanceToScene);					// This is equivalent to having a diffuse light at the camera position

    		finalColor = lambert*diffuseColor*alpha;						// Modulate lighting term with color of the material (red)
  	}
	
	gl_FragColor = vec4(finalColor, 1.0);							// Output final color
}