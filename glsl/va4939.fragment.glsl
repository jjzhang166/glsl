// Raytracing: simple implementation
// Author: Davor Badrov
// Currently heavily based on http://glsl.heroku.com/e
// simple raytracing implementation, with a sphere, part1
// status: hitting geometry	(a sphere) and drawing it with a solid color

#ifdef GL_ES
	precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//define sphere position
vec4 sphere1 = vec4(0.0, 1.0, 0.0, 1.0);

// function determines if there was a intersection with the sphere
// parameters: camera ray origin and distance, and sphere coordinates
// return value: distance to the intersection or -1.0 if there was no intersection
// description:
// this function "draws" the sphere and offsets it from center
// (it actually isn't drawn like standard 3D objects, only it's
//	 equation is defined, it's drawn by checking collisions between
//   the defined sphere and the rays shot from the camera),
// after that it checks for collision
float iSphere(in vec3 ro, in vec3 rd, in vec4 sphere)
{
	// place the sphere with an offset from the origin
	// oc - offset center
	vec3 oc = ro - sphere.xyz;

	// define if there's any intersection point between the ray and the sphere
	float r = 1.0;
	float b = 2.0*dot(oc, rd);
	float c = dot(oc, oc) - r*r;
	float h = b*b - 4.0*c;
	
	// if there wasn't any colission, return -1
	if (h < 0.0) return -1.0;

	// otherwise return the distance
	float t = (-b - sqrt(h))/2.0;
	return t;
}

// function determines wether the ray hit any objects or not,
// parameters: camera ray origin and direction, and a output parameter - distance to the intersection
// return value: returns the identifier - what the ray hit, if there wasn't any colission return -1.0
// decription:
// function checks for the intersection between the geometry (scene) and the rays shot from camera
// it finds the closest ray intersection, identifies the type of object the ray hit and the distance
// to the object trough the output parameter
float intersect(in vec3 ro, in vec3 rd, out float resT)
{
	// contains distance to the currently closest point of intersection,
	// used to determine the closest object that intersects with the ray
	resT = 1000.0;
	
	float id = -1.0;		// identifier for the intersection, default is -1.0 - no intersection
	// float tmin = -1.0;	// - unneeded variable, probably to contain minimum distance to intersection
	
	// determine the distance to the intersection
	float tsph = iSphere(ro, rd, sphere1);
	
	// if the intersection exists:
	// 	identify it (id will be used later for coloring)
	//	and set the current distance to the closest object intersection
	if (tsph > 0.0)
	{
		id = 1.0;
		resT = tsph;
	}
	return id;	
}

void main( void ) {
	//get pixel coordinate
	vec2 uv = ( gl_FragCoord.xy / resolution.xy );
	
	//generate a ray
	vec3 ro = vec3(0.0, 0.5, 3.0);
	vec3 rd = normalize( 
		vec3(-1.0+2.0*uv*vec2(resolution.x/resolution.y, 1.0),
		-1.0)
	);
	
	// check for intersection, t is the distance from the camera/ray origin to ray-object intersection
	float t;
	float intersection = intersect(ro, rd, t);
	
	// default pixel drawing color
	vec3 color = vec3(0.65);
	
	// if there was a intersection change the drawing color based on the type of intersection
	if (intersection == 1.0)
	{
		color = vec3(0.3, 0.5, 0.8);	
	}
	
	// modify the color a bit - makes all the colors a bit lighter
	color = sqrt(color);
	
	gl_FragColor = vec4( color, 1.0 );
}