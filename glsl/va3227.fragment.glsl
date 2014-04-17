// Mini raytracer from scratch by blogoben, work in progress
// 3004.0: plane with glowing checker texture and camera rotations
// 3004.1: changed order of rotations and factors for camera control
// 3004.2: extensive re-factoring, addition of flat-rendered spheres
// 2996.1: saved 3004.2 into 2996.1 from another computer
// 2996.2: additional re-factoring for readibility (not working yet), and spheres only (no plane)

#ifdef GL_ES
precision highp float;
#endif 

// Uniform variables set by sandbox:
uniform vec2  resolution; // Size in pixels of rendered rectangle
uniform float time;       // Time (in seconds?) since reload/modification of page
uniform vec2  mouse;      // Virtual position of mouse pointer inside rendered rectangle i.e. 0<x<1, 0<y<1
uniform int texture;

// Constants
#define PI 3.14159265
#define EPSILON 0.0000001
#define MAX_ITERRATIONS 5

// Material type for Phong shading
struct Material
{
	int texture;		// 0: No texture, 1: Checker, 2: Sky
	vec3 color;		// Basic color if no texture, color at infinity for textures
	float ambientFactor;
	float diffuseFactor;
	float specularFactor;
	float refractionIndex;
};

// Sphere type including material
struct Sphere
{
	vec3 centre;
	float radius;
	Material material;
};

// Definition of objects in the scene (initialization in initScene)
const int objectsCount = 2;
Sphere sceneObjects[objectsCount];
const int lightsCount = 1;
Sphere sceneLights[lightsCount];
vec3 ambientLight;

void initScene()
{
	// Central ball
	sceneObjects[0] = Sphere(vec3(0.0,0.0,0.0), 0.4,
		Material(0, vec3(0.0,0.0,1.0), 0.1, 0.1, 0.1, 1.2));
	
	// Floor
	sceneObjects[1] = Sphere(vec3(0.0, -20001.0, 0.0), 20000.0,
		Material(1, vec3(0.0,0.0,0.0), 0.0, 0.0, 0.0, 1e20));

	// Lights
	sceneLights[0] = Sphere(vec3(0.7,-0.7,0.0), 0.2,
		Material(0, vec3(0.0,0.0,0.0), 0.0, 0.0, 0.0, 1e20));
}

struct Ray
{
	vec3 startPoint;
	vec3 directionVector;
	float currentDistance;
	vec3 intersectionPoint;
	vec3 intersectionNormal;
};

// Objects defined as macros (simple but ugly)
#define BALL vec3(0.0,0.0,0.0), 0.4
#define LIGHT vec3(0.7,-0.7,0.0), 0.2
#define PLANE vec3(0.0,2.0,0.0), vec3(0.0,1.0,0.0)


// Computes intersection of ray with sphere, and updates ray structure if intersection point
//  is nearer than the one given in the ray structure, returns true if there is a ray update
bool crossSphere(inout Ray ray, in Sphere sphere)
{
	// Simply checks if current intersection is nearer than sphere
	if(ray.currentDistance < distance(ray.startPoint, sphere.centre)-sphere.radius)
		return false;
	
	// Computes factors of the ax^2+bx+c=0 equation giving both intersections with sphere,
	//  see http://www.csee.umbc.edu/~olano/435f02/ray-sphere.html
	float a = dot(ray.directionVector, ray.directionVector);
	float b = 2.0*dot(ray.directionVector, ray.startPoint - sphere.centre);
	float c = dot(ray.startPoint - sphere.centre, ray.startPoint - sphere.centre) - sphere.radius*sphere.radius;
	
	// Computes discriminant
	float disc = b*b-4.0*a*c;
	
	// Returns -1 if there is no intersection at all
	if(disc<EPSILON)
		return false;
	
	// Computes both intersections
	float d1 = (-b+sqrt(disc))/(2.0*a);
	float d2 = (-b-sqrt(disc))/(2.0*a);
	
	// Checks if bothe intersection points are behind eye or on sphere
	if(d1<EPSILON && d2<EPSILON)
		return false;
	
	// Check if eye is inside sphere, i.e. one intersection point is behind eye, otherwise normal case
	float i = (d1*d2<EPSILON)? max(d1,d2): min(d1,d2);
	
}


// Computes the normal to a sphere (defined by a centre and radius) at a given point, seen from the given eye point
// Assumes that the intersection point is within the sphere
vec3 sphereIntersectionNormal(vec3 eye, vec3 intersection, vec3 centre, float radius)
{
	// Computes normal towards outside of sphere
	vec3 normal = normalize(intersection-centre);

	// Returns normal or -normal according to eye position with respect to sphere interior
	return faceforward(normal, intersection-eye, normal);
}


// Computes the distance between the given eye point and a sphere defined by its center and a radius
//  in the direction of the given ray
float sphereIntersectionDistance(vec3 eye, vec3 ray, vec3 centre, float radius)
{
	// Computes factors of the ax^2+bx+c=0 equation giving both intersections with sphere,
	//  see http://www.csee.umbc.edu/~olano/435f02/ray-sphere.html
	float a = dot(ray, ray);
	float b = 2.0*dot(ray, eye-centre);
	float c = dot(eye-centre, eye-centre) - radius*radius;
	
	// Computes discriminant
	float disc = b*b-4.0*a*c;
	
	// Returns -1 if there is no intersection at all
	if(disc<EPSILON)
		return -1.0;
	
	// Computes both intersections
	float d1 = (-b+sqrt(disc))/(2.0*a);
	float d2 = (-b-sqrt(disc))/(2.0*a);
	
	// Checks if bothe intersection points are behind eye or on sphere
	if(d1<EPSILON && d2<EPSILON)
		return -1.0;
	
	// Check if eye is inside sphere, i.e. one intersection point is behind eye
	if(d1*d2<EPSILON)
		return max(d1,d2);
	
	// Normal case if both intersection points are visible
	return min(d1,d2);
}

// Computes pixel color for smooth, pulsating checker texture, using texture coordinates (u,v)
//  Distance to origin is used to hide aliasing effects
vec3 smoothCheckerTextureColor(float u, float v)
{
	// Computes factors used in the dynamic texture of the plane, sin(x)*cos(y) to give a smooth checker
	float l = log(log(0.4+length(vec2(u,v))));
	float f1 = sin(u*6.0)*cos(v*6.0);
	float ft = exp(f1+sin(time)/4.0+0.5)/2.1;
	
	// Final texture computed by blending the color to black to hide aliasing towards infinity
	return mix(vec3(ft, ft, ft), vec3(0.0,0.0,0.0), clamp(l/1.0,0.0,1.0));
}

// Main recursive function
vec3 raycastColor(vec3 eye, vec3 ray, int iter)
{
	// Check if we reached limit of iterrations
	if(iter==0) return vec3(0.0,0.0,0.0);
	else iter--;
	
	// Prepares variables to find minimum distance to intersected object
	float mindist=1e20;
	int type;
	
	// Central ball
	float distBall = sphereIntersectionDistance(eye, ray, BALL);
	if(distBall>0.0)
	{
		mindist = distBall;
		type = 1;
	}
	
	// Light
	float distLight = sphereIntersectionDistance(eye, ray, LIGHT);
	if(distLight>0.0 && distLight<mindist)
	{
		mindist = distLight;
		type=2;
	}

	// Plane
	//float distPlane = planeIntersectionDistance(eye, ray, PLANE);
	float distPlane = sphereIntersectionDistance(eye, ray, vec3(0.0, 20001.0, 0.0), 20000.0);
	if(distPlane>0.0 && distPlane<mindist)
	{
		mindist = distPlane;
		type=3;
	}

	// Computes intersection point with nearest object
	vec3 inter = eye + distPlane*ray;

	// Case 1: ball outside
	if(type==1)
		return vec3(0.0,0.0,1.0);
	
	// Case 2: light
	if(type==2)
		return vec3(1.0,1.0,1.0);
	
	// Case 3: Plane
	if(type==3)
	{
		// Computes texture at intersection point
		vec3 intersectionColor = smoothCheckerTextureColor(inter.x, inter.z);
		
		// Casts reflected ray recursively
		if(iter>0)
		{
			//vec3 normal = planeIntersectionNormal(eye, inter, PLANE);
			
			//vec3 reflectedColor = raycastColor(inter, reflect(ray, normal), iter-1);
			
			vec3 reflectedColor = smoothCheckerTextureColor(inter.x,inter.z);
			return reflectedColor;
		}
	}
	
	// Otherwise returns black
	return vec3(0.0,0.0,0.0);
}

void main(void)
{
	// Inits the objects of the scene
	initScene();
	
	// Computes aspect of rendered rectangle
	float aspect = resolution.x / resolution.y;
	
	// Computes virtual position of rendered point inside a 2x2 square
	vec2 p = vec2( ( 2.0*gl_FragCoord.x/resolution.x - 1.0 ) * aspect,
			 2.0*gl_FragCoord.y/resolution.y - 1.0 );

	// Computes angles for changing viewpoint by moving the mouse and time
	float rotx =3.55-mouse.y*1.5;
	float roty = -mouse.x*4.0+time/20.0;
	
	// Computes rotations matrix around Y then X axes (see blogoben.wordpress.com)
	mat3 rotations = mat3( cos(roty), 0.0, sin(roty),
			       0.0,       1.0,       0.0,
			      -sin(roty), 0.0, cos(roty));
	rotations *=     mat3(1.0,       0.0,        0.0,
			      0.0, cos(rotx), -sin(rotx),
			      0.0, sin(rotx),  cos(rotx));

	// Defines constant viewpoint at (0,0.0,4)
	vec3 eye = vec3(0.0, 0.0, 4.0);

	// Defines normalized ray to intersect with scene, from eye to rendered point at z=2
	vec3 ray = normalize(vec3(p.xy, 2.0)- eye);
	
	// Rotates eye and ray, i.e. moves observer of the scene according to mouse position
	eye *= rotations;
	ray *= rotations;

	// Calls main rendering function and returns color
   	gl_FragColor = vec4(raycastColor(eye, ray, MAX_ITERRATIONS),1.0);
}

/*
// Computes the distance between the given eye point and a plane (defined by a point and a normal)
//  in the direction of the given ray
float planeIntersectionDistance(vec3 eye, vec3 ray, vec3 point, vec3 normal)
{
	// Computes indicator of parallelism between ray and the plane
	float d = dot(normal, ray);
	
	// Exits if ray and plane are nearly parallel
	if(abs(d)<EPSILON)
		return -1.0;
	
	// Computes distance
	return dot(normal, point - eye)/d;
}

// Computes the normal to a plane (defined by a point and a normal) at a given point, seen from the given eye point
// Assumes that the intersection point is within the plane 
vec3 planeIntersectionNormal(vec3 eye, vec3 intersection, vec3 point, vec3 normal)
{
	// Returns normal or -normal according to eye position with respect to plane
	return faceforward(normal, intersection-eye, normal);
}
*/
