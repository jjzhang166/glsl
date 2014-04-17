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
	vec3 hitPoint; // hit point
	vec3 normal; // normal
	vec3 color;
	int hit;
};

// ray-objects functions

void intersectionSphere(Sphere sphere, Ray ray, inout Intersection isect)
{

 // struct Sphere { 
 //   double rad;       // radius 
 //   Vec p, e, c;      // position, emission, color 
 //   Refl_t refl;      // reflection type (DIFFuse, SPECular, REFRactive) 
 //   Sphere(double rad_, Vec p_, Vec e_, Vec c_, Refl_t refl_): 
 //     rad(rad_), p(p_), e(e_), c(c_), refl(refl_) {} 
 //   double intersect(const Ray &r) const { // returns distance, 0 if nohit 
 //     Vec op = p-r.o; // Solve t^2*d.d + 2*t*(o-p).d + (o-p).(o-p)-R^2 = 0 
 //     double t, eps=1e-4, b=op.dot(r.d), det=b*b-op.dot(op)+rad*rad; 
 //     if (det<0) return 0; else det=sqrt(det); 
 //     return (t=b-det)>eps ? t : ((t=b+det)>eps ? t : 0); 
 //   } 
 // }; 
	float t;
	float epsilon = 1e-4;
	vec3 op = ray.origin - sphere.center;
	float b = dot(op, ray.direction);
	float c = dot(op, op) - (sphere.radius * sphere.radius);
	// solve determinant
	float determinant = b * b - c;
	if (determinant > 0.0)
	{
		determinant = sqrt(determinant);
		t = -b - determinant;
		if ( t > epsilon  && t < isect.t)
		{
			isect.t = t;
			isect.hit = 1;
			isect.color = sphere.color;
			// calculate normal
			vec3 p = vec3(ray.origin.x + ray.direction.x * t,
						  ray.origin.y + ray.direction.y * t,
						  ray.origin.z + ray.direction.z * t);		
			vec3 n = p - sphere.center;
			n = normalize(n);
			isect.normal = n;
			isect.hitPoint = p;
		}
	}
}


// calculate reflection
vec3 reflection(vec3 dir, vec3 normal)
{
	dir = normalize(dir);
	return dir - normal * 2.0 * dot(normal, dir);
}



Sphere sphere[MAXSPHERES];

void Intersect(Ray ray, inout Intersection isect)
{
	for(int c = 0; c < MAXSPHERES; c++)
	{
		intersectionSphere(sphere[c], ray, isect);
	}
}

// is anything between the points "src" (point on surface) and "dst" (light source)?
// need to calculate shadows 
bool rayBlocked(vec3 src, vec3 dst)
{
	vec3 dir = dst - src;
	float length = sqrt(dot(dir, dir));
	dir = dir / length;

	Intersection i;
	i.t = length - 0.01; // because we use a spehere as a light point!
	i.hit = 0;
	// create a new ray
	Ray ray;
	ray.origin = src;
	ray.direction = normalize(dir);
	Intersect(ray, i);
	return i.hit != 0 ? true : false;
}

// calculate color
vec3 calculateLight(vec3 src, vec3 dst, Intersection i)
{
	vec3 color = vec3(.15, .15, .15); // ambient color

	if (!rayBlocked(src, dst))
	{
		// diffuse calculation goes here
		vec3 dir = (dst - src); // change to sub! :-S  pay attention of this!
		float invDist= 1.0 / sqrt(dot(dir, dir));
		dir = dir*invDist; // normalize
		float diffuse = dot(dir, i.normal);
		if (diffuse > 0.0)
		{
			color += color * diffuse * i.color * invDist *  13.35;
		}
		
		// specular and reflection calculation goes here

		dir = normalize(dir);
		float attenuation = 1.5;
		// vec3 lightReflect =  i.normal * dot(i.normal * 2.0, dir) - dir;
		vec3 lightReflect = i.normal * dot(i.normal * 2.0, dir) - dir;
		float cosFactor = dot(i.normal, lightReflect);
		if (cosFactor > 0.0)
		{
			float thisSpecular =  pow(cosFactor, 200.0);
			thisSpecular *= attenuation;
			color += thisSpecular;
		}
	}

	return color;
}


// simple tracer
vec3 traceRay(Ray ray, Intersection isect, vec3 lightPos)
{
	vec3 color = vec3 (.0, .0, .0);
	Intersect(ray, isect);
	if (isect.hit != 0)
	{
		color = calculateLight(isect.hitPoint, lightPos, isect);
	}
	return color;
}



void main()
{
	// Objects
	sphere[0].radius = .25;
	sphere[0].center = vec3(.5+(cos(time*2.2)), 0.0, -1.23+(sin(time*2.3)));
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

	// sphere light
	sphere[8].radius = .0;
	// sphere[8].center = vec3((cos(time*.5)), .05+0.325, -0.2 -(cos(time)));
	sphere[8].center = vec3(0., 2., -1.39);

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


	color.rgb =  traceRay(ray, isect, sphere[8].center);


// Intersect(ray, isect);
// 	if (isect.hit !=0)
// 	{
// 		color.rgb = isect.color;
// 	}


	gl_FragColor = color;
	gl_FragColor.a = 1.0;
}