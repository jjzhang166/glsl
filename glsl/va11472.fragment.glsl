precision mediump float;

uniform float time;
uniform vec2 resolution;

#pragma mark - Data Types

struct Ray {
	vec3 origin;
	vec3 direction;
};

struct Sphere {
	vec3 center;
	float radius;
};

struct Plane {
	vec3 center;
	vec3 normal;
	float radius;
};

#pragma mark - Model Objects

Sphere sphere1;
Plane plane1;

#pragma mark - Function prototypes

float intersect(in Ray ray, out float resT);
float iSphere(in Ray ray, in Sphere sph);
float iPlane(in Ray ray, in Plane plane);
vec3  nSphere(in vec3 pos, in Sphere sph);

#pragma mark - Main Shader

void main(void)
{
	// Instantiate model objects
	sphere1.center = vec3(1.0, 1.0, 1.0);
	sphere1.radius = 1.0;
	plane1.center = vec3(0.0, 0.0, 0.0);
	plane1.normal = normalize(vec3(0.0, 1.0, 0.0));
	plane1.radius = 4.0;

	// Configure Light
	vec3 light = normalize (vec3(0.57703));

#define M_PI 3.14159265359

	// uv are the pixel coordinates, from 0 to 1
	vec2 uv = (gl_FragCoord.xy/.5 / vec2(resolution.x, resolution.y));

	// let's move that sphere
	sphere1.center.x = cos(time);
	sphere1.center.z = cos(time);

	// we generate a ray with origin ro and direction rd
	Ray ray;
	ray.origin = vec3(0.0, 2.0, 5.0);
	ray.direction = normalize(vec3((-1.0 + 1.0 * uv) * vec2(resolution.x/resolution.y, 1.0), -1.0));

	// we intersect the ray with the 3d scene
	float t;
	float id = intersect( ray, t);

	vec3 col = vec3(0.7);
	if (id > 0.5 && id < 1.5) {
		// if we hit the sphere
		vec3 pos = ray.origin + t * ray.direction;
		vec3 nor = nSphere(pos, sphere1);
		float dif = clamp (dot(nor, light), 0.0, 1.0);
		float ao = 0.5 + 0.5 * nor.y;
		col = vec3(0.9, 0.8, 0.6) * dif * ao + vec3(0.1, 0.2, 0.4) * ao;
	} else if (id > 1.5) {
		// we hit the plane
		vec3 pos = ray.origin + t * ray.direction;
		vec3 nor = plane1.normal;
		float dif = clamp(dot(nor, light), 0.0, 1.0);
		float amb = smoothstep(0.0, 2.0 * sphere1.radius, length(pos.xz - sphere1.center.xz));
		pos = pos * M_PI;

		col = amb*ceil(vec3(sin(pos.x)*sin(pos.z)));
		col += 0.4;
	}

	col = sqrt(col);

	gl_FragColor = vec4(col, 1.0);
}

#pragma mark - Intersection

float intersect(in Ray ray, out float resT)
{
	resT = 1000.0;
	float id = -1.0;
	float tsph = iSphere(ray, sphere1); // intersect with a sphere
	float tpla = iPlane(ray, plane1); // intersect with a plane

	if (tsph > 0.0) {
		id = 1.0;
		resT = tsph;
	}
	if (tpla > 0.0 && tpla < resT) {
		id = 2.0;
		resT = tpla;
	}

	return id;
}

float iSphere(in Ray ray, in Sphere sph)
{
	// so, a sphere centered at the origin has equation |xyz| = r
	// meaning, |xyz|^2 = r^2, meaning <xyz,xyz> = r^2
	// now, xyz = ro + t*rd, therefore |ro|^2 + t^2 + 2<ro,rd>t - r^2 = 0
	// which is a quadratic equation, so
	vec3 oc = ray.origin - sph.center;
	float b = 2.0 * dot(oc, ray.direction);
	float c = dot(oc, oc) - sph.radius * sph.radius;
	float h = b*b - 4.0*c;

	if (h < 0.0) {
		return -1.0;
	}

	float t = (-b -sqrt(h)) / 2.0;
	return t;
}

float iPlane(in Ray ray, in Plane plane)
{
	float denominator = dot(plane.normal, ray.direction);

	if (denominator == 0.0) {
		return -1.0;
	}

	float nominator = dot(plane.normal, plane.center - ray.origin);

	float r = nominator / denominator;
	if (r > 0.1) {
		return r;
	}

	return -1.0;
}

#pragma mark - Normal Calculation

vec3 nSphere(in vec3 pos, in Sphere sph)
{
	return (pos-sph.center) / sph.radius;
}
