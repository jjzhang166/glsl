// a small ray tracing based on Kevin Beason's smallpt project
// http://www.kevinbeason.com/smallpt/


#ifdef GL_ES
precision mediump float;
#endif

#define MAXSPHERES 9

uniform float time;

uniform vec2 resolution;
	vec3 org = vec3(0,0.5,0);
	vec2 pixel = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;

    // compute ray origin and direction
    float asp = resolution.x / resolution.y;
    vec3 dir = normalize(vec3(asp*pixel.x, pixel.y, -1.0));

// Structures

struct Ray {
	vec3 origin;
	vec3 direction;
};

struct Sphere {
	vec3 center;
	float radius;
	vec3 color;
};

struct Intersection
{
	float t;
	vec3 p; // hit point
	vec3 n; // normal
	vec3 color;
	int hit;
};

// ray-objects functions

void intersectionSphere(Sphere sphere, Ray ray, inout Intersection isect)
{
	float t;
	vec3 op = ray.origin - sphere.center;
	float b = dot(op, ray.direction);
	float c = dot(op, op) - (sphere.radius * sphere.radius);
	// solve determinant
	float determinant = b * b - c;
	if (determinant > 0.0)
	{
		determinant = sqrt(determinant);
		t = -b - determinant;
		if ( t > 0.0 && t < isect.t)
		{
			isect.t = t;
			isect.hit = 1;
			isect.color = sphere.color;
			// calcule hit point and normal
		}
	}
}

Sphere sphere[MAXSPHERES];

void Intersect(Ray ray, inout Intersection isect)
{
	for(int c = 0; c < MAXSPHERES; c++)
	{
		intersectionSphere(sphere[c], ray, isect);
	}
}

void main()
{
	// Objects
	sphere[0].radius = 1.5;
	sphere[0].center = vec3(.5+(cos(time*2.2)), 0.0, -3.2+(sin(time*2.3)));
	sphere[0].color = vec3(.25, .75, .25);

	sphere[1].radius = .5;
	sphere[1].center = vec3(-1.0+(sin(time*1.)), 1., -1.5+(cos(time*1.)));
	sphere[1].color = vec3(.75, .75, .25);

	// wall right
	sphere[2].radius = 1e5;
	sphere[2].center = vec3(1e5+2.5, 40.8, 81.6);
	sphere[2].color = vec3(.25, .25, .75);

	// wall left
	sphere[3].radius = 1e5;
	sphere[3].center = vec3(-1e5-2.5, 40.8, 81.6);
	sphere[3].color = vec3(.75, .25, .25);

	// wall back
	sphere[4].radius = 1e5;
	sphere[4].center = vec3(50., 40.8, -1e5-3.4);
	sphere[4].color = vec3(.75, .75, .75);

	// wall top
	sphere[5].radius = 1e5;
	sphere[5].center = vec3(50., 1e5+2.2, 40.8);
	sphere[5].color = vec3(.75, .75, .75);

	// wall bottom
	sphere[6].radius = 1e5;
	sphere[6].center = vec3(50., -1e5-1.5, 40.8);
	sphere[6].color = vec3(.75, .75, .75);

	// wall front
	sphere[7].radius = 1e5;
	sphere[7].center = vec3(50., 40.8, 1e5+3.4);
	sphere[7].color = vec3(.0, .0, .0);

	// lite
	sphere[8].radius = .05;
	sphere[8].center = vec3((cos(time*.5)), .05+1.325, -1.15);

	sphere[8].color = vec3(1.0, 1.0, 1.0);

	Ray ray;
	ray.origin = org;
	ray.direction = normalize(dir);

	Intersection isect;
	isect.t = 1e20;
	isect.hit = 0;

	vec4 color = vec4(.0, .0, .0, 0);
	vec4 backgroundColor = vec4(.55, .75, .8, 0);
	color = backgroundColor;


Intersect(ray, isect);
	if (isect.hit !=0)
	{
		color.rgb = isect.color;
	}


	gl_FragColor = color;
	gl_FragColor.a = 1.0;
}