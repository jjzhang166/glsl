// Mini raytracer from scratch by blogoben, work in progress
// 3004.0: plane with glowing checker texture and camera rotations
// 3004.1: changed order of rotations and factors for camera control
// 3004.2: extensive re-factoring, addition of flat-rendered spheres
// 2996.1: saved 3004.2 into 2996.1 from another computer, strange bug regarding rotations order XY or YX
// 2996.2: additional re-factoring for readibility (not working yet), and spheres only (no plane)
// 2996.3: new code used (spheres in a table) but still bug
// 2996.4: code works now, bug linked to nested structs (Material in Object, now only big Object)
// 2996.5: code now includes Phong illumination but does not work (strange noise), suspect bug in shader compiler
// 2996.6: bug identified (reflected ray random hit of same intersection point), now shadow works
// 2996.7: finally working, Phong computation split into 3 functions, checker texture changed, satellite ball added
// 2996.8: additional light, satellite ball nearer center, less color saturation on floor
// 2996.9: added simple single reflection

#ifdef GL_ES
precision highp float;
#endif 

// Uniform variables set by sandbox:
uniform vec2  resolution; // Size in pixels of rendered rectangle
uniform float time;       // Time (in seconds?) since reload/modification of page
uniform vec2  mouse;      // Virtual position of mouse pointer inside rendered rectangle i.e. 0<x<1, 0<y<1

// Constants
#define PI 3.14159265
#define EPSILON 0.0000001

// Object i.e. sphere type including material
// Workaround: nested structs do not work on Chrome/Linux/GM45, should be supported by GLSL ES 2.0
struct Object
{
	int index;		// Used to compare objects
	vec3 centre;
	float radius;
	int type;		// 0: Normal, 1: Light, 2: Checker texture, 3: Sky texture
	vec3 color;		// Basic color if no texture, color at infinity for textures
	float ambientFactor;
	float diffuseFactor;
	float specularFactor;
	float specularExponent;
	float refractionIndex;
	
};
// Types used in the Object struc
#define OT_NORMAL	0
#define OT_LIGHT	1
#define OT_SKY		2
#define OT_CHECKER	3

// Definition of objects in the scene (initialization in initScene)
const int objectsCount = 6;
const int lightsCount = 2;
Object sceneObjects[objectsCount];
vec3 ambientLight;

// Initializes the array of objects and global variables
// Remark: the lights must be at the beginning of the array, the indices must fit
void initScene()
{
	// Ambient light
	ambientLight = vec3(0.1, 0.1, 0.1);
	
	// Light circling
	sceneObjects[0] = Object(0, vec3(1.0+0.4*sin(time), 1.0+0.4*cos(time), 1.0), 0.15,
		OT_LIGHT, vec3(1.0,1.0,1.0), 0.0, 0.0, 0.0, 0.0, 0.0);

	// Light oscillating
	sceneObjects[1] = Object(1, vec3(1.5*sin(time/3.0), 1.1+0.2*sin(time*2.0), 1.5*cos(time/3.0)), 0.15,
		OT_LIGHT, vec3(1.0,1.0,1.0), 0.0, 0.0, 0.0, 0.0, 0.0);

	// Central ball
	sceneObjects[2] = Object(2, vec3(0.0,0.0,0.0), 0.4,
		OT_NORMAL, vec3(0.0,0.0,0.6), 0.1, 0.4, 0.3, 8.0, 0.0);
	
	// Satellite ball
	sceneObjects[3] = Object(3, vec3(1.1*sin(time/10.0),0.0, 1.1*cos(time/10.0)), 0.3,
		OT_NORMAL, vec3(0.2,0.3,0.5), 0.1, 0.4, 0.3, 10.0, 0.0);
	
	// Floor
	float r = 1000.0;
	vec3 bc = vec3(0.0, 0.0, 0.0);
	sceneObjects[4] = Object(4, vec3(0.0, r, 0.0), r+1.0,
		OT_CHECKER, bc, 0.3, 0.1, 0.4, 100.0, 0.0);

	// Sky
	sceneObjects[5] = Object(5, vec3(0.0,0.0,0.0), 25.0,
		OT_SKY, bc, 0.0, 0.0, 0.0,0.0, 0.0);
}

// Ray used to compute intersections
struct Ray
{
	vec3  startPoint;
	vec3  directionVector;
	float currentDistance;
	vec3  intersectionPoint;
	vec3  intersectionNormal;
	int   intersectionType;		// 0: exterior, 1: interior
};
// Types used in ray object
#define RT_EXTERIOR	0
#define RT_INTERIOR	1	

// Initializes ray with main and default values
Ray initializeRay(vec3 start, vec3 direction)
{
	Ray ray;
	ray.startPoint = start;
	ray.directionVector = direction;
	ray.currentDistance = 1e20;
	
	return ray;
}

// Computes normal at intersection point once nearest object is found (type and distance are set)
void finalizeRay(inout Ray ray, in Object object)
{
	// Computes intersection point coordinates given the distance to this point
	ray.intersectionPoint = ray.startPoint + ray.currentDistance*ray.directionVector;
	
	// Computes normal towards exterior or interior
	vec3 n = normalize(ray.intersectionPoint - object.centre);	// Temp. normal towards exterior
	ray.intersectionNormal = ray.intersectionType==RT_EXTERIOR ? n : -n; 	// Retains normal opposite for interior intersection
}

// Computes intersection of ray with object i.e. sphere, and updates ray structure if intersection point
//  is nearer than the one given in the ray structure, returns true if there is intersection
bool crossObject(inout Ray ray, Object sphere, int excludedType)
{
	// Computes factors of the ax^2+bx+c=0 equation giving both intersections with sphere,
	//  see http://www.csee.umbc.edu/~olano/435f02/ray-sphere.html
	float a = dot(ray.directionVector, ray.directionVector);
	float b = 2.0*dot(ray.directionVector, ray.startPoint - sphere.centre);
	float c = dot(ray.startPoint - sphere.centre, ray.startPoint - sphere.centre) - sphere.radius*sphere.radius;
	
	// Computes discriminant
	float disc = b*b-4.0*a*c;
	
	// Returns if there is no intersection at all
	if(disc<EPSILON)
		return false;
	
	// Computes both intersections
	float d1 = (-b+sqrt(disc))/(2.0*a);
	float d2 = (-b-sqrt(disc))/(2.0*a);
	
	// Re-order both values
	float mind = min(d1,d2);
	float maxd = max(d1,d2);			
	
	// Checks if both intersection points are behind eye
	if(maxd < -EPSILON)
		return false;
	
	// Checks if first intersection is behind eye
	if(mind < -EPSILON)
		if(maxd > ray.currentDistance || excludedType == RT_INTERIOR)
			return false;
		else
		{
			ray.currentDistance = maxd;
			ray.intersectionType = RT_INTERIOR;
			return true;
		}
	else
		if(mind > ray.currentDistance || excludedType == RT_EXTERIOR)
			return false;
		else
		{
			ray.currentDistance = mind;
			ray.intersectionType = RT_EXTERIOR;
			return true;
		}
}

// Checks all objects in the scene, and returns a copy of it (assumed there is always one)
// GLSL ES 2.0 workaround: the function returns an object, not an index, because arrays
//  can be accessed only using an iterrated index
Object crossScene(inout Ray ray, int excludedIndex, int excludedType)
{
	// Finds nearest object
	Object object;
	for(int i=0; i<objectsCount; i++)
		if(i!=excludedIndex)
		if(crossObject(ray, sceneObjects[i], i==excludedIndex?excludedType:-1))
			object = sceneObjects[i];
			
	// Computes normal etc
	finalizeRay(ray, object);
	
	return object;
}


// Computes Phong ambient illumination component (uses global ambient light variable)
vec3 ambientColorTerm(Object object)
{
	return object.ambientFactor*ambientLight;
}

// Computes Phong diffuse illumination component given the normal at intersection point (in ray),
//  direction to light and light color
vec3 diffuseColorTerm(Object object, Ray ray, vec3 lightDirection, vec3 lightColor)
{
	float f = dot(lightDirection, ray.intersectionNormal);
	if(f>0.0)
		return f*object.diffuseFactor*lightColor;
	else
		return vec3(0.0,0.0,0.0);
}

// Computes Phong specular illumination component given the normal and incident vector (in ray),
//  the eye position, the direction to light and light color
vec3 specularColorTerm(Object object, Ray ray, vec3 lightDirection, vec3 lightColor, vec3 eye)
{
	float f = dot(reflect(-lightDirection, ray.intersectionNormal), normalize(eye - ray.intersectionPoint));
	
	if(f>0.0)
		return pow(f,object.specularExponent)*object.specularFactor*lightColor;
	else
		return vec3(0.0,0.0,0.0);
}


// Computes influence of all lights on given object at intersection point in given (finalized) ray
vec3 getLightingColor(Ray ray, Object object)
{
	// Temporary color
	vec3 c = ambientColorTerm(object);

	// Iterrates through all lights
	for(int i=0;i<lightsCount;i++)
	{
		// Gets direction to light
		vec3 lightDir = normalize(sceneObjects[i].centre - ray.intersectionPoint);
		
		// Computes shadow ray only if there is a chance that the ray goes to the light
		if(dot(ray.intersectionNormal, lightDir)>EPSILON)
		{
			Ray shadowRay = initializeRay(ray.intersectionPoint, lightDir);
		
			// Finds intersection with light or opaque object --> shadow
			Object o = crossScene(shadowRay, object.index, ray.intersectionType);

			// Checks if the object found is a light, if yes computes illumination
			if(o.type == OT_LIGHT)
			{
				c +=  diffuseColorTerm(object, ray, lightDir, o.color);
				c += specularColorTerm(object, ray, lightDir, o.color, ray.startPoint);				
			}
		}
	}

	return c;
}

vec3 cloudySkyTextureColor(float u, float v)
{
	return vec3(0.0,0.0,0.0);
}


// Computes pixel color for smooth, pulsating checker texture, using texture coordinates (u,v)
//  Distance to origin is used to hide aliasing effects
vec3 smoothCheckerTextureColor(float u, float v, vec3 infinityColor)
{
	// Computes factors used in the dynamic texture of the plane, sin(x)*cos(y) to give a smooth checker
	float l = log(log(0.4+length(vec2(u,v))));
	float m = 6.0, d = 0.7, f = d*sin(u*m)*cos(v*m)+(1.0-d)*sin(time);
	float ft = 2.0+0.4*f;
	
	// Final texture computed by blending the color to black to hide aliasing towards infinity
	return 0.6*mix(vec3(0.5*ft, 0.3*ft, 0.7*ft), infinityColor, clamp(l/1.6,0.0,1.0));
}

// Retruns the own color of the given oject at intersection point in given finlaized ray
vec3 basicObjectColor(Ray ray, Object object)
{
	// Computes basis color depending on type
	if(object.type==OT_NORMAL || object.type==OT_LIGHT || object.type==OT_SKY)
		return object.color;

	// Calls texture for checker
	if(object.type == OT_CHECKER)
		return smoothCheckerTextureColor(ray.intersectionPoint.x, ray.intersectionPoint.z, object.color);
	
	return vec3(0.0,0.0,0.0);
}

vec3 getReflectionColor(Ray ray, Object object)
{
	// Creates new reflected ray
	Ray reflectionRay = initializeRay(ray.intersectionPoint, reflect(ray.directionVector, ray.intersectionNormal));
	
	Object o = crossScene(reflectionRay, object.index, ray.intersectionType);

	return 0.6*basicObjectColor(reflectionRay, o);
}
// Main function giving the color of a pixel of the screen by checking all objects in the scene (defined
//  in global arrays sceneObjects and sceneLights), given the position of the obserevr (eye) and the direction
//  looked at (normalized ray vecor). Adds color components to the current color depending on the
//  level (level 0 being the most important one)
vec3 raytraceColor(vec3 eye, vec3 direction)
{
	// Initialisation of ray
	Ray ray = initializeRay(eye, direction);
	
	// Gets the object in the table 
	Object o = crossScene(ray, -1, -1);

	// Temporary color
	vec3 tempColor = basicObjectColor(ray, o);
	
	// Applies Phong shading and reflections for all objects except lights and sky
	if(o.type!=OT_LIGHT && o.type!=OT_SKY)
		tempColor += getLightingColor(ray, o) + getReflectionColor(ray, o);

	// Returns color
	return tempColor;
}

void main(void)
{
	// Inits the objects of the scene
	initScene();
	
	// Computes aspect of rendered rectangle
	float aspect = resolution.x / resolution.y;
	
	// Computes virtual position of rendered point inside a 2x2 square
	vec2 p = vec2( (       2.0*gl_FragCoord.x/resolution.x - 1.0 ) * aspect,
			 1.0 - 2.0*gl_FragCoord.y/resolution.y );

 	// Computes angles for changing viewpoint by moving the mouse and time
	float rotx =4.42-mouse.y*1.5;
	float roty = mouse.x*10.0+time/20.0;
	
	// Computes rotations matrices around X and Y axes (see blogoben.wordpress.com)
	mat3 rotationMatrixX = mat3( 1.0,       0.0,        0.0,
				     0.0, cos(rotx), -sin(rotx),
				     0.0, sin(rotx),  cos(rotx));

	mat3 rotationMatrixY = mat3( cos(roty), 0.0,  sin(roty),
				     0.0,       1.0,        0.0,
				    -sin(roty), 0.0,  cos(roty));

	// Defines constant viewpoint at (0,0.0,4)
	vec3 eye = vec3(0.0, 0.0, 4.0);

	// Defines normalized ray to intersect with scene, from eye to rendered point at z=2
	vec3 ray = normalize(vec3(p.xy, 2.0)- eye);
	
	// Rotates eye and ray, i.e. moves observer of the scene according to mouse position
	eye = (eye * rotationMatrixX) * rotationMatrixY;
	ray = (ray * rotationMatrixX) * rotationMatrixY;
	
	// Calls main rendering function and returns color
   	gl_FragColor = vec4(raytraceColor(eye, ray), 1.0);
}
