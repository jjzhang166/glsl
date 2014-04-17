#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 eyePos = vec3(0.0, 0.0, -10.0);
float screenZ = -1.0;
vec3 backgroundColour = vec3(0.0,0.0,0.1);
float noIntersectionT = -1.0;

struct Ray {
	vec3 start;
	vec3 direction;
};
	
struct Material {
	vec3 colour;
};
	
struct Sphere {
	vec3 position;
	float radius;
	Material material;	
};
	
struct Plane {
	vec3 position;
	vec3 normal;
	Material material1;
	Material material2;
	float squareSize;
};
	
struct Intersection {
	vec3 position;
	float t;
	vec3 normal;
	Material material;
};
	
Material defaultMaterial = Material ( vec3(1.0,0.0,0.0) );
Material blackMaterial = Material ( vec3(0.1,0.1,0.1) );
Material whiteMaterial = Material ( vec3(1.0,1.0,1.0) );
	
bool intersectSphere(Ray ray, Sphere sphere, inout Intersection intersection) {
	
	float t0, t1;
	
	vec3 l = sphere.position - ray.start;
	float tca = dot(l, ray.direction);
	if ( tca < 0.0 )
		return false;
	float d2 = dot (l, l) - (tca * tca);
	float r2 = sphere.radius*sphere.radius;
	if ( d2 > r2 )
		return false;
	float thc = sqrt(r2 - d2);
	t0 = tca - thc;
	
	intersection.position = ray.start + t0 * ray.direction;
	intersection.t = t0;
	intersection.normal = normalize ( intersection.position - sphere.position );
	intersection.material = sphere.material;
	
	return true;
}

bool intersectPlane(Ray ray, Plane plane, inout Intersection intersection) {

	float t = dot ( plane.normal, plane.position - ray.start ) / dot ( plane.normal, ray.direction );
	
	if ( t < 0.0 )
		return false;
	
	intersection.position = ray.start + t * ray.direction;
	intersection.t = t;
	intersection.normal = plane.normal;
	
	intersection.material = whiteMaterial;
	
	return true;
	
}

Intersection noIntersection () {
	return Intersection(vec3(0.0,0.0,0.0),noIntersectionT,vec3(0.0,0.0,0.0),defaultMaterial);
}

bool hasIntersection(Intersection i) {
	return i.t != noIntersectionT;	
}
	
vec3 traceRay(Ray ray, inout Intersection minIntersection) {

	Intersection intersection = noIntersection();
	Sphere sphere = Sphere(vec3(-0.5,0.0,0.5),0.4, defaultMaterial);
	
	if ( intersectSphere ( ray, sphere, intersection ) ) {
		if ( !hasIntersection(minIntersection) || intersection.t < minIntersection.t )
			minIntersection = intersection;
	}
	
	sphere = Sphere(vec3(0.5,0.0,0.5),0.4, Material(vec3(0.0,0.0,1.0)) );
	
	if ( intersectSphere ( ray, sphere, intersection ) ) {
		if ( !hasIntersection(minIntersection) || intersection.t < minIntersection.t )
			minIntersection = intersection;
	}

	Plane plane = Plane(vec3(0.0,-2.0,0.0), vec3(0.0,1.0,0.0), blackMaterial, whiteMaterial, 0.2);
	
	if ( intersectPlane ( ray, plane, intersection ) ) {
		if ( !hasIntersection(minIntersection) || intersection.t < minIntersection.t )
			minIntersection = intersection;
	}
	
	
	if ( hasIntersection(minIntersection) )
		return minIntersection.material.colour;
	else
		return backgroundColour;
}

vec3 recurseRay(Ray ray) {
	
	vec3 colour = backgroundColour;
	
	Intersection intersection = noIntersection();
	
	colour = traceRay(ray, intersection);
	
	if ( hasIntersection(intersection) ) {

		Ray reflectedRay = Ray ( intersection.position, reflect ( ray.direction, intersection.normal ) );
		intersection = noIntersection();
		colour += traceRay ( reflectedRay, intersection );
		
		if ( hasIntersection(intersection) ) {
			//colour = vec3(0.0,1.0,0.0);
			reflectedRay = Ray ( intersection.position, reflect ( reflectedRay.direction, intersection.normal ) );
			intersection = noIntersection();
			colour += traceRay ( reflectedRay, intersection );
		}
		 
	}

	return colour;
}
	
void main( void ) {

	float y = (gl_FragCoord.y * 2.0)/resolution.y - 1.0;
	float ratio = resolution.x/resolution.y;
	float x = ((gl_FragCoord.x * 2.0)/resolution.x - 1.0) * ratio;
	vec3 pixelPos = vec3(x,y,screenZ);
	Ray ray = Ray(pixelPos, normalize(pixelPos - eyePos));

	gl_FragColor = vec4(recurseRay(ray),1.0);
}