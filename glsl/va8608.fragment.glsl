#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
vec2 rand2(vec2 pos)
{
  return fract(pow(pos+2.0,pos.yx+2.0)*2222.0);
}
 
vec2 rand(vec2 pos)
{
  return rand2(rand2(pos));
}

struct Sphere
{
	vec3 center;
	float radius;
};
struct Ray
{
	vec3 orign;
	vec3 direction;
};
struct Intersection
{
	vec3 position;
	vec3 normal;
	float time;
};
float lengthSqr(vec3 x)
{
	return dot(x,x);
}
bool sphereIntersection(Sphere sphere, Ray ray, inout Intersection isect)
{
	float r = sphere.radius;
	
	float b = 2.0*(dot(ray.direction,ray.orign)-dot(sphere.center,ray.direction));
	float c = lengthSqr(sphere.center)+lengthSqr(ray.orign)-2.0*dot(sphere.center,ray.orign)-r*r;

	float det = b*b-4.0*c;
	if(det>0.0)
	{
		float t0 = (-b+sqrt(det))/2.0;
		float t1 = (-b-sqrt(det))/2.0;
		float tret = isect.time;
		
		bool hasHit = false;
		if(tret>t0&&t0>0.0)
		{
			hasHit = true;
			tret = t0;
		}
		if(tret>t1&&t1>0.0)
		{
			hasHit = true;
			tret = t1;
		}
		if(hasHit)
		{
			isect.time = tret;
			isect.position = ray.orign + ray.direction * tret;
			isect.normal = normalize(isect.position - sphere.center);
			return true;
		}
	}
	return false;
}

bool intersectionAll(Ray ray, inout Intersection isect)
{

	
	bool ret = false;
	const int nSpheres = 2;
	Sphere spheres[nSpheres];
	spheres[0].center = vec3(0,0,5);	spheres[0].radius = 1.0;
	spheres[1].center = vec3(0,-200000.0-5.0,5);	spheres[1].radius = 200000.0;
	for(int i=0;i<nSpheres;i++)
	{
		if(sphereIntersection(spheres[i], ray, isect))
		{
			ret = true;
		}
	}
	
	return ret;
}
vec3 raytrace(vec2 uv)
{
	vec3 ret;
	vec3 cameraPos = vec3(0,0,0);
	vec3 DL = vec3(-1,-1,3);
	vec3 DL2DR = vec3(2,0,0);
	vec3 DL2UL = vec3(0,2,0);
	vec3 targetPos = DL + uv.x*DL2DR + uv.y*DL2UL;
	
	Ray ray;
	ray.orign = cameraPos;
	ray.direction = normalize(targetPos - cameraPos);
	

	
	Intersection isect;
	isect.time = 100.0;

	if(intersectionAll(ray, isect))
	{
		ret = vec3(dot(isect.normal,normalize(vec3(1))));
	}
	return ret;
}
void main( void ) {

	vec2 uv = ( gl_FragCoord.xy / resolution.xy ) ;
	vec2 seed = uv;
	const int nLoop = 10;
	vec3 sum = vec3(0.0);
	for(int i=0;i<nLoop;i++)
	{
		vec2 uvTmp = uv + rand(seed)*0.01;
		sum += raytrace(uvTmp);
		seed = normalize(uvTmp);
	}
	gl_FragColor.xyz = sum/float(nLoop);

}