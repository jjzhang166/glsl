#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

/*
 *
 * An attempt to do a simple ray-trace style sphere using a geometric ray-sphere collision test.
 * It doesn't work, strangely displacing the sphere in z while it is moved in x. 
 * If you know why and wish to enlight, please email me palebluedot@gmail.com =D
 *
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
	
	// Discard rays starting inside the sphere.
	vec3 rayOriginToSphereCenter = sphere.center - ray.origin;
	float rayOriginToSphereCenterLengthSq = dot( rayOriginToSphereCenter, rayOriginToSphereCenter );
	if( rayOriginToSphereCenterLengthSq < 0.0 ) {
		return color;
	}
	
	// Discard rays "looking away" from the sphere.
	float projectionOnRaySq = dot( rayOriginToSphereCenter, ray.direction );
	if( projectionOnRaySq < 0.0 ) {
		return color;
	}
	
	// Discard rays that miss the sphere.
	float closestDistToSphereSq = rayOriginToSphereCenterLengthSq - projectionOnRaySq;
	float halfRayDistInsideSphereSq = sphere.radius * sphere.radius - closestDistToSphereSq;
	if( halfRayDistInsideSphereSq < 0.0 ) {
		return color;
	}
	
	color = vec3( 1.0 );
	
	return color;	
}

void main( void ) {

	vec2 position = 2.0 * gl_FragCoord.xy / resolution.xy - 1.0;
	position.x *= resolution.x / resolution.y;
	//position = abs( position );
	
	vec2 mouseCentered = mouse - 0.5;
	
	Sphere sphere;
	sphere.radius = 0.25;
	sphere.center = vec3( 2.8 * mouseCentered.x, 0.0, 0.0 );

	Ray ray;
	ray.origin = vec3( position.x, position.y, -focus );
	ray.direction = vec3(0,0, focus );
	ray.direction = normalize( ray.direction ); // Normalizing direction will aid several calculations.
	
	vec3 color = hitSphereColor( ray, sphere );
	
	//gl_FragColor = vec4( position, 0.0, 0.0 );
	//gl_FragColor = vec4( ray.direction, 0.0 );
	gl_FragColor = vec4( color, 1.0 );

}