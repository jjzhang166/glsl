#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 eyePos = vec3(0.0, 0.0, -10.0);
float screenZ = -1.0;
vec3 backgroundColour = vec3(0.0,0.0,0.1);
float noIntersection = -1.0;

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
	
struct Intersection {
	vec3 position;
	float t;
	vec3 normal;
	Material material;
};
	
Material defaultMaterial = Material ( vec3(1.0,0.0,0.0) );
	
	
bool intersectSphere(Ray ray, Sphere sphere, in Intersection intersection) {
	
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

	
vec3 traceRay(Ray ray) {

	Intersection minIntersection = Intersection(vec3(0.0,0.0,0.0),noIntersection,vec3(0.0,0.0,0.0),defaultMaterial);

	Intersection intersection = Intersection(vec3(0.0,0.0,0.0),noIntersection,vec3(0.0,0.0,0.0),defaultMaterial);
	Sphere sphere = Sphere(vec3(0.0,0.0,1.0),1.0, defaultMaterial);
	
	if ( intersectSphere ( ray, sphere, intersection ) ) {
		if ( minIntersection.t == noIntersection || intersection.t < minIntersection.t )
			minIntersection = intersection;
	}
	
	if ( minIntersection.t != noIntersection )
		return minIntersection.material.colour; 
	
	return backgroundColour;
}
	
void main( void ) {

	float y = (gl_FragCoord.y * 2.0)/resolution.y - 1.0;
	float ratio = resolution.x/resolution.y;
	float x = ((gl_FragCoord.x * 2.0)/resolution.x - 1.0) * ratio;
	vec3 pixelPos = vec3(x,y,screenZ);
	Ray ray = Ray(pixelPos, pixelPos - eyePos);

	gl_FragColor = vec4(traceRay(ray),1.0);
}