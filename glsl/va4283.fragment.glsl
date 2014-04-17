#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

/*
 * Ray tracing 101 with geometric ray-sphere collision test.
 * Work in progress...
 */

#define focus 1.0

struct Ray {
	vec3 origin;
	vec3 direction;
};

struct Sphere {
	vec3 center;
	float radius;
};
	
vec3 hitSphereColor( Ray ray, Sphere sphere ) {
	
	vec3 color = vec3( 0.0 );
	
	float radiusSq = sphere.radius * sphere.radius;
	
	// Discard rays starting inside the sphere.
	vec3 delta = sphere.center - ray.origin; // vector from ray origin to sphere center
	float deltaSq = dot( delta, delta ); // squared length of such vector
	if( deltaSq < radiusSq ) {
		return color;
	}
	
	// Discard rays "looking away" from the sphere.
	float tca = dot( delta, ray.direction ); // projection of delta on ray direction
	if( tca < 0.0 ) {
		return color;
	}
	
	// Discard rays that miss the sphere.
	float tcasq = tca * tca; // tca's squared length
	float d = deltaSq - tcasq; // length of shortest path from ray to sphere center
	float thcsq = radiusSq - d; // half the length of the ray inside the sphere
	if( thcsq < 0.0 ) {
		return color;
	}
	//return vec3( 1.0 );
	//return vec3( 100.0 * thcsq );
	
	// Find collision point.
	float t = tca - sqrt( thcsq );
	vec3 intersect = ray.origin + t * ray.direction;
	//return intersect;
	
	// Find normal.
	vec3 normal = ( intersect - sphere.center ) / sphere.radius;
	//return normal;
	
	// Diffuse light contribution.
	vec3 viewDir = vec3( 0.0, 0.0, -1.0 );
	float diffuse = dot( viewDir, normal );
	return vec3( diffuse );	
}

void main( void ) {

	float aspectRatio = resolution.x / resolution.y;
	
	vec2 position = 2.0 * gl_FragCoord.xy / resolution.xy - 1.0;
	position.x *= aspectRatio;
	
	vec2 mouseCentered = 2.0 * ( mouse - 0.5 );
	mouseCentered.x *= aspectRatio;
	
	Sphere sphere;
	sphere.radius = 0.25;
	sphere.center = vec3( mouseCentered.x, mouseCentered.y, 0.0 );

	Ray ray;
	ray.origin = vec3( 0.0, 0.0, -focus );
	ray.direction = vec3( position, focus );
	ray.direction = normalize( ray.direction ); // some calcs rely on this to be normalized
	
	vec3 color;
	color += hitSphereColor( ray, sphere );
	
	//gl_FragColor = vec4( position, 0.0, 0.0 );
	//gl_FragColor = vec4( ray.direction, 0.0 );
	gl_FragColor = vec4( color, 1.0 );

}