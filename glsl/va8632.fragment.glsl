#ifdef GL_ES
precision highp float;
#endif

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

float sdSphere( vec3 p, float s )
{
  return length(p)-s;
}	
	
float sdTorus( vec3 p, vec2 t)							//IQs RoundBox (try other objects http://www.iquilezles.org/www/articles/distfunctions/distfunctions.htm)
{
  vec2 q = vec2(length(p.xz)-t.x,p.y/2.);
  return length(q)-t.y;
}
		
float opRep( vec3 p, vec3 c )
{
    vec3 q = mod(p,c)-0.5*c;
    return sdSphere(q,1.0);
    //return sdTorus( q, vec2(1.,.5) );
}		

float displacement( vec3 p)
{
    return sin(20.*p.x)*sin(20.*p.y)*sin(20.*p.z);
}

float opDisplace( vec3 p )
{
    float d1 = sdSphere(p, 2.0);
    float d2 = displacement(p);
    return d1+d2;
}
float GetDistanceToScene(in vec3 p){
  	float distance = opRep(p.xzy,vec3(10., 10., 10.));
	return distance;
}

void main(void){
	
  // General parameter setup
	vec2 vPos = 2.0*gl_FragCoord.xy/resolution.xy - 1.0; 					// map vPos to -1..1
	float t = time*1.1;									// time value, used to animate stuff
	float screenAspectRatio = resolution.x/resolution.y;					// the aspect ratio of the screen (e.g. 16:9)
	vec3 finalColor = vec3(0.1);								// The background color, dark gray in this case
	
   //Camera setup
	Camera cam;										// Make a struct holding all camera parameters
  	cam.lookAt = vec3(0,0,0);								// The point the camera is looking at
	cam.position = vec3(sin(mouse.x)*20.0, 2, cos(mouse.y)*40.0);						// The position of the camera
	cam.up = vec3(0,1,0);									// The up vector, change to make the camera roll, in world space
  	cam.forward = normalize(cam.lookAt-cam.position);					// The camera forward vector, pointing directly at the lookat point
  	cam.left = cross(cam.forward, cam.up);							// The left vector, which is perpendicular to both forward and up
 	cam.up = cross(cam.left, cam.forward);							// The recalculated up vector, in camera space
 
	vec3 screenOrigin = (cam.position+cam.forward); 					// Position in 3d space of the center of the screen
	vec3 screenHit = screenOrigin + vPos.x*cam.left*screenAspectRatio + vPos.y*cam.up; 	// Position in 3d space where the camera ray intersects the screen
  
	cam.rayDir = normalize(screenHit-cam.position);						// The direction of the current camera ray

  //Raymarching
  	const float MIN_DISTANCE = 0.2;								// Distance to scene that we will count as a hit
	const float MAX_DEPTH=40.0;								// Distance from camera that we will count as a miss
	const int MAX_STEPS = 256;								// Maxmimum amount of ray marching steps before counting the ray as a miss
	
  	float distanceToScene = 1.0;								// Initial distance to scene, should be initialized as 1
	float distanceFromCamera = 0.0;								// The ray starts at the camera, so 0
	
  	vec3 raymarchPosition;									// Variable holding the current position along the camera ray
  	
  	for(int i=0;i<MAX_STEPS;i++){
    		if (abs(distanceToScene)< MIN_DISTANCE || distanceFromCamera>MAX_DEPTH) break;	// Exit if we hit something, or if the ray goes past MAX_DEPTH
    	
		distanceFromCamera += distanceToScene;						// If we didn't exit, move away from the camera...
    		raymarchPosition = cam.position+cam.rayDir*distanceFromCamera;			// Calculate new position along the camera ray
		distanceToScene = GetDistanceToScene(raymarchPosition);				// Check how far the new position is away from the scene
  	}
	
  //Lighting
  
	vec3 diffuseColor,normal;
	const vec3 e=vec3(0.01,0,0);								// Epsilon value, used to calculate the hit normal
	
  	if (distanceFromCamera<MAX_DEPTH){							// If this is true, it means we hit something
    		diffuseColor = vec3(0.7, 0.5, 0.2);						// Set diffuse color for cube to red
    		normal=normalize(								// Calculate normal... somehow :)
      			vec3(distanceToScene-GetDistanceToScene(raymarchPosition-e.xyy),
           		distanceToScene-GetDistanceToScene(raymarchPosition-e.yxy),
           		distanceToScene-GetDistanceToScene(raymarchPosition-e.yyx)));
    		
		float lambert = dot(normal*1.2, -cam.rayDir);					// This is equivalent to having a diffuse light at the camera position

    		finalColor = lambert*diffuseColor + vec3(0., 0.03, 0.1);						// Modulate lighting term with color of the material (red)
  	}
	
	gl_FragColor = vec4(finalColor, 1.0);							// Output final color
}