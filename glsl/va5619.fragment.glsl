#ifdef GL_ES
precision highp float;
#endif

// Made a mess again - PLaiD

// I am trying to understand raymarching and decided to clean up a simple example I found and gave it proper names for all the variables
// Hope this helps someone better understand how this works.
// countfrolic@gmail.com

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;
	
struct Camera {
	vec3 position;
	vec3 lookAt;
	vec3 rayDir;
	vec3 forward, up, left;
};

struct Quat {
	vec4 q;
};

// Normalize quaternion
Quat normalize(Quat q) {
	float magnitude = sqrt(
		pow(q.q.x, 2.0)
		+pow(q.q.y, 2.0)
		+pow(q.q.z, 2.0) 
		+pow(q.q.w, 2.0) );
	q.q.x /= magnitude;
	q.q.y /= magnitude;
	q.q.z /= magnitude;
	q.q.w /= magnitude;
	return q;
}

// Create quaternion from axis angle
Quat quat(float x, float y, float z, float a) {
	float sina = sin( a / 2.0 );
	float cosa = cos( a / 2.0 );
	Quat q;
	q.q = vec4(x * sina, y * sina, z * sina, cosa);
	return normalize(q);
}

// Typecast vec4 as quaternion
Quat quat(vec4 p) {
	Quat q;
	q.q = p;
	return normalize(q);
}

// Multiply quaternions
Quat mult(Quat q, Quat o) {
	return quat( vec4 ( 
		(q.q.w*o.q.w -q.q.x*o.q.x -q.q.y*o.q.y -q.q.z*o.q.z),
		(q.q.w*o.q.x +q.q.x*o.q.w +q.q.y*o.q.z -q.q.z*o.q.y),
		(q.q.w*o.q.y -q.q.x*o.q.z +q.q.y*o.q.w +q.q.z*o.q.x),
		(q.q.w*o.q.z +q.q.x*o.q.y -q.q.y*o.q.x +q.q.z*o.q.w)) );
}

// Transform vector using quaternion
vec3 transform(Quat q, vec3 p) {
	float xx = q.q.x*q.q.x;
	float xy = q.q.x*q.q.y;
	float xz = q.q.x*q.q.z;
	float xw = q.q.x*q.q.w;
	float yy = q.q.y*q.q.y;
	float yz = q.q.y*q.q.z;
	float yw = q.q.y*q.q.w;
	float zz = q.q.z*q.q.z;
	float zw = q.q.z*q.q.w;
    
    return vec3(
	    p.x*(1.0 - 2.0 *( yy + zz )) +p.y*(2.0       *( xy - zw )) +p.z*(2.0       *( xz + yw )),
	    p.x*(2.0       *( xy + zw )) +p.y*(1.0 - 2.0 *( xx + zz )) +p.z*(2.0       *( yz - xw )),
	    p.x*(2.0       *( xz - yw )) +p.y*(2.0       *( yz + xw )) +p.z*(1.0 - 2.0 *( xx + yy )));
}

#define SPHERE 1
#define BOX 2
#define RBOX 3
#define TORUS 4
#define CONE 5
#define CYLINDER 6
#define PLANE 7
#define PRISM_HEX 8
#define PRISM_TRI 9

// Structure to store primative data
struct Prim {
    int type;  // Primative type from defines
    float v1;  // 1d vec for distance functions
    vec2  v2;  // 2d vec for distance functions
    vec3  v3;  // 3d vec for distance functions
    vec4  v4;  // 4d vec for distance functions
    vec3 rep;  // repeat (set to all zeros if repetition is not wanted)
    vec3 t;    // translation vec
    Quat q;    // quaternion used for primative rotation
};

// Distance deformation function
float deform(float d) {
	return d*0.1;
}

// Distance function
float GetDistanceToPrimative(in vec3 v, Prim p) {
	//IQs primitives expressed as distance functions (http://www.iquilezles.org/www/articles/distfunctions/distfunctions.htm)
	
	vec3 tv = v;                        
	tv += p.t;                          // translate vector using primitive's translation vector
	tv = mod(tv, p.rep)-0.5*p.rep;      // apply repetition
	tv = transform(p.q, tv);            // transform vector using primitive's quaternion
	
	// Use the primitive's distance function
	float d;
    	if(p.type == SPHERE) {
            	d = length(tv)-p.v1;
    	} else if (p.type == BOX) {
        	d = length(max(abs(tv)-p.v3,0.0));
	} else if (p.type == RBOX) {
        	d = length(max(abs(tv)-p.v3,0.0))-p.v1;
        } else if (p.type == TORUS) {
        	vec2 qv2 = vec2(length(tv.xz)-p.v2.x,tv.y);
        	d = length(qv2)-p.v2.y;
	} else if (p.type == CONE) {
		float ql = length(tv.xy);
		vec2 c = normalize(p.v2);
    		d = dot(normalize(c),vec2(ql,tv.z));
	} else if (p.type == CYLINDER) {
		d = length(tv.xz-p.v3.xy)-p.v3.z;
	} else if (p.type == PLANE) {
		vec4 n = normalize(p.v4);
		d = dot(tv,n.xyz) + n.w;
	} else if (p.type == PRISM_HEX) {
    		vec3 q = abs(tv);
    		d = max(q.z-p.v2.y,max(q.x+q.y*0.57735,q.y*1.1547)-p.v2.x);
	} else if (p.type == PRISM_TRI) {
		vec3 q = abs(tv);
    		d = max(q.z-p.v2.y,max(q.x*0.866025+tv.y*0.5,-tv.y)-p.v2.x*0.5);
	}
	
	return deform(d); // Apply deformation function
}

void main(void){
	
  // General parameter setup
	vec2 vPos = 2.0*gl_FragCoord.xy/resolution.xy - 1.0; 					// map vPos to -1..1
	float t = time*0.1;									// time value, used to animate stuff
	float screenAspectRatio = resolution.x/resolution.y;					// the aspect ratio of the screen (e.g. 16:9)
	vec3 finalColor = vec3(0.1);								// The background color, dark gray in this case
	
   //Camera setup
	Camera cam;										// Make a struct holding all camera parameters
  	cam.lookAt = vec3(0,0,0);								// The point the camera is looking at
	cam.position = vec3(4.0+sin(time*1.2382)*4.0, 4.0, 4.0+sin(time*0.84923)*3.0);						        // The position of the camera
	cam.up = vec3(0,1,0);									// The up vector, change to make the camera roll, in world space
  	cam.forward = normalize(cam.lookAt-cam.position);					// The camera forward vector, pointing directly at the lookat point
  	cam.left = cross(cam.forward, cam.up);							// The left vector, which is perpendicular to both forward and up
 	cam.up = cross(cam.left, cam.forward);							// The recalculated up vector, in camera space
 
	vec3 screenOrigin = (cam.position+cam.forward); 					// Position in 3d space of the center of the screen
	vec3 screenHit = screenOrigin + vPos.x*cam.left*screenAspectRatio + vPos.y*cam.up; 	// Position in 3d space where the camera ray intersects the screen
  
	cam.rayDir = normalize(screenHit-cam.position);						// The direction of the current camera ray

  //Primitive setup
	Prim p;
	p.type = 8;
	p.v4 = vec4(1.0, 1.0, 1.0, 1.0);
	p.v3 = vec3(1.0, 1.0, 1.0);
	p.v2 = vec2(1.0, 1.0);
	p.v1 = 0.1;
	p.rep = vec3(10.0,10.0,10.0);
	p.t = vec3(-time*15.0 + sin(time)*5.0, -time*15.0 + cos(time)*5.0,-time*15.0);
	p.q = quat(1.0, 0.6+cos(time*1.113207), sin(time/2.17381), time/2.21141);
	
  //Raymarching
  	const float MIN_DISTANCE = 0.1;								// Distance to scene that we will count as a hit
	const float MAX_DEPTH    = 256.0;							// Distance from camera that we will count as a miss
	const int MAX_STEPS      = 1024;							// Maxmimum amount of ray marching steps before counting the ray as a miss
	
  	float distanceToScene = 1.0;								// Initial distance to scene, should be initialized as 1
	float distanceFromCamera = 0.0;								// The ray starts at the camera, so 0
	
  	vec3 raymarchPosition;									// Variable holding the current position along the camera ray
  	
  	for(int i=0;i<MAX_STEPS;i++){
    		if (abs(distanceToScene)< MIN_DISTANCE || distanceFromCamera>MAX_DEPTH) break;	// Exit if we hit something, or if the ray goes past MAX_DEPTH
    	
		distanceFromCamera += distanceToScene;						// If we didn't exit, move away from the camera...
    		raymarchPosition = cam.position+cam.rayDir*distanceFromCamera;			// Calculate new position along the camera ray
		distanceToScene = GetDistanceToPrimative(raymarchPosition, p);				// Check how far the new position is away from the scene
  	}
	
  //Lighting
  	vec3 fogColor = vec3(1.4,0.9,1.0);
	vec3 diffuseColor,normal;
	const vec3 e=vec3(0.01,0,0);								// Epsilon value, used to calculate the hit normal
	
  	if (distanceFromCamera<MAX_DEPTH){							// If this is true, it means we hit something
    		diffuseColor = vec3(1.0 - distanceFromCamera/MAX_DEPTH, 0.3 - distanceFromCamera/MAX_DEPTH, 0.8 - distanceFromCamera/MAX_DEPTH);
    		normal=normalize(								// Calculate normal... somehow :)
      			vec3(distanceToScene-GetDistanceToPrimative(raymarchPosition-e.xyy, p),
           		distanceToScene-GetDistanceToPrimative(raymarchPosition-e.yxy, p),
           		distanceToScene-GetDistanceToPrimative(raymarchPosition-e.yyx, p)));
    		
		float lambert = dot(normal, -cam.rayDir);					// This is equivalent to having a diffuse light at the camera position

	        float fogAmount = (1.0 - clamp(distanceFromCamera*0.0055,0.0,1.0) );            // Calculate fog based on distance from camera
		
    		finalColor = lambert*diffuseColor;						// Modulate lighting term with color of the material
		finalColor = mix(fogColor, finalColor, fogAmount);                              // Mix fog with final color
  	} else {
		
		finalColor = fogColor;	                                                        // Too far away from camera, just draw fog
	}
	
	gl_FragColor = vec4(finalColor, 1.0);							// Output final color
}