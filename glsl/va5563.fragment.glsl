#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const int raytraceDepth = 8;


struct Ray
{
	vec3 org;
	vec3 dir;
};
	
struct Sphere
{
	vec3 c;
	float r;
	vec3 col;
};
	
struct Plane
{
	vec3 p;
	vec3 n;
	vec3 col;
};
	

struct Intersection
{
	float t;
	vec3 p;     // hit point
	vec3 n;     // normal
	int hit;
	vec3 col;
};

float EaseOutBounce(float t, float b, float c, float d) {
	if ((t/=d) < (1.0/2.75)) {
		return c*(7.5625*t*t) + b;
	} else if (t < (2.0/2.75)) {
		return c*(7.5625*(t-=(1.5/2.75))*t + .75) + b;
	} else if (t < (2.5/2.75)) {
		return c*(7.5625*(t-=(2.25/2.75))*t + .9375) + b;
	} else {
		return c*(7.5625*(t-=(2.625/2.75))*t + .984375) + b;
	}
}

void sphere_intersect(Sphere s,  Ray ray, inout Intersection isect)
{
	// rs = ray.org - sphere.c
	vec3 rs = ray.org - s.c;
	float B = dot(rs, ray.dir);
	float C = dot(rs, rs) - (s.r * s.r);
	float D = B * B - C;

	if (D > 0.0)
	{
		float t = -B - sqrt(D);
		if ( (t > 0.0) && (t < isect.t) )
		{
			isect.t = t;
			isect.hit = 1;

			// calculate normal.
			vec3 p = vec3(ray.org.x + ray.dir.x * t,
			ray.org.y + ray.dir.y * t,
			ray.org.z + ray.dir.z * t);
			vec3 n = p - s.c;
			n = normalize(n);
			isect.n = n;
			isect.p = p;
			isect.col = s.col;
		}
	}
}

void plane_intersect(Plane pl, Ray ray, inout Intersection isect)
{
	float d = -dot(pl.p, pl.n);
	float v = dot(ray.dir, pl.n);

	if (abs(v) < 1.0e-6)
		return; // the plane is parallel to the ray.

	float t = -(dot(ray.org, pl.n) + d) / v;

	if ( (t > 0.0) && (t < isect.t) )
	{
		isect.hit = 1;
		isect.t   = t;
		isect.n   = pl.n;

		vec3 p = vec3(ray.org.x + t * ray.dir.x,
		ray.org.y + t * ray.dir.y,
		ray.org.z + t * ray.dir.z);
		isect.p = p;
		float offset = 0.2;
		vec3 dp = p + offset;
		
		if ((mod(dp.x, 1.0) > 0.5 && mod(dp.z, 1.0) > 0.5) || (mod(dp.x, 1.0) < 0.5 && mod(dp.z, 1.0) < 0.5))
			isect.col = pl.col;
		else
			isect.col = pl.col * 0.9;
	}
}

Sphere sphere[4];
Plane plane;

#define PI 3.14159

int seed = 0;
float random()
{
	seed = int(mod(float(seed)*1364.0+626.0, 509.0));
	return float(seed)/509.0;
}

void BouncySphere( float random, Ray r, inout Intersection i ) {
	float t = mod(time+random, 2.);
	float x = sin(random*PI)*t; 
	float z = cos(random*PI)*t;
		
	float dropHeight = 5.*random;
	float y = dropHeight-EaseOutBounce(x-0.5, 0., dropHeight, 1.);
	float radius = (2.-x)*0.2;
	vec3 pos = vec3(x, y+radius, z);
	
	sphere[0].c   = pos;
	sphere[0].r   = radius;
	sphere[0].col = vec3(1,0.3,0.3);

	
	sphere_intersect(sphere[0], r, i);
}



void Intersect(Ray r, inout Intersection i)
{
	
	BouncySphere(.565, r, i);
	BouncySphere(.234, r, i);	
	BouncySphere(.987, r, i);
	BouncySphere(.235, r, i);
	BouncySphere(.765, r, i);
	BouncySphere(.134, r, i);	
	BouncySphere(.487, r, i);
	BouncySphere(.535, r, i);
	
	plane_intersect(plane, r, i);
}


vec3 computeLightShadow(in Intersection isect)
{
	int i, j;
	int ntheta = 16;
	int nphi   = 16;
	float eps  = 0.001;

	// Slightly move ray org towards ray dir to avoid numerical probrem.
	vec3 p = vec3(isect.p.x + eps * isect.n.x,
				isect.p.y + eps * isect.n.y,
				isect.p.z + eps * isect.n.z);

	vec3 lightPoint = vec3(5,5,5);
	Ray ray;
	ray.org = p;
	ray.dir = normalize(lightPoint - p);

	Intersection lisect;
	lisect.hit = 0;
	lisect.t = 1.0e+30;
	lisect.n = lisect.p = lisect.col = vec3(0, 0, 0);
	Intersect(ray, lisect);
	if (lisect.hit != 0)
		return vec3(0.0,0.0,0.0);
	else
	{
		float shade = max(0.0, dot(isect.n, ray.dir));
		shade = pow(shade,2.0) + shade * 0.5;
		return vec3(shade,shade,shade);
	}
	
}

void main( void ) 
{
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	position -= vec2( 0.5,0.5 );
	position.x *= 2.0;
	//asdfasdf
	float ss = sin(time*0.3);
	float cc = cos(time*0.3);
	//vec3 org = vec3(ss*4.0,0,cc*4.0);
	vec3 org = vec3(ss*6.0,.5,cc*6.0);
	vec3 dir = normalize(vec3(position.x*cc-ss,position.y, -position.x*ss-cc));
	
	
	plane.p = vec3(0,-0., 0);
	plane.n = vec3(0, 1.0, 0);
	plane.col = vec3(0.3);
	
	Ray r;
	r.org = org;
	r.dir = normalize(dir);
	vec4 col = vec4(0,0,0,1);
	float eps  = 0.0001;
	vec3 bcol = vec3(1,1,1);
	for (int j = 0; j < raytraceDepth; j++)
	{
		Intersection i;
		i.hit = 0;
		i.t = 1.0e+30;
		i.n = i.p = i.col = vec3(0, 0, 0);
			
		Intersect(r, i);
		if (i.hit != 0)
		{
			col.rgb += bcol * i.col * computeLightShadow(i);
			bcol *= i.col;
		}
		else
		{
			break;
		}
				
		r.org = vec3(i.p.x + eps * i.n.x,
					 i.p.y + eps * i.n.y,
					 i.p.z + eps * i.n.z);
		r.dir = reflect(r.dir, vec3(i.n.x, i.n.y, i.n.z));
	}
	gl_FragColor = col;
	
	
}