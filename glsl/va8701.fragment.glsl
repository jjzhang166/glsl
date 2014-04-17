#ifdef GL_ES
precision highp float;
#endif


uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;



vec2 rand2(vec2 n)
{	
  return fract(pow((n.xy)*222.0+1.0, n.yx));
}
vec2 rand(vec2 n)
{
	return rand2(rand2((n+1.0)/2.0));
}
float fresnel(vec3 i, vec3 n, float f0)
{
	float c = dot(i,n);
	float t = 1.0-c;
	return f0 + (1.0-f0)*t*t*t*t*t;
}

struct Intersection
{
	float time;
	vec3 position;
	vec3 normal;
	int materialId;
};
	
struct Ray
{
	vec3 orign;
	vec3 direction;
};
	
struct Sphere
{
	vec3 center;
	float radius;
	int materialId;
};
struct Query
{
	Ray ray;
	vec3 coeff;
	bool isInside;
};
struct Stack
{
	int stackSize;
	Query q0;
	Query q1;
	Query q2;
	Query q3;
	/*
	Query q4;
	Query q5;
	Query q6;
	Query q7;
	*/
};
	
float lengthSquare(vec3 x)
{
	return dot(x,x);
}
	
bool sphereIntersection(Sphere sphere, Ray ray, inout Intersection isect)
{
	float rd = sphere.radius;
	float a = 2.0*(dot(ray.direction,ray.orign)-dot(sphere.center,ray.direction));
	float b = lengthSquare(ray.orign) + lengthSquare(sphere.center) - 2.0*dot(sphere.center, ray.orign) - rd*rd;
	
	float det = a*a-4.0*b;
	if(det>0.0)
	{
		float t0 = -(sqrt(det)+a)/2.0;
		float t1 = (sqrt(det)-a)/2.0;
		
		bool hashit = false;
		float tret = isect.time;
		if(tret>t0 && t0 > 0.0)
		{
			tret = t0;
			hashit = true;
		}
		if(tret>t1 && t1 > 0.0)
		{
			tret = t1;
			hashit = true;
		}
		if(hashit)
		{
			isect.time = tret;
			isect.position = ray.orign + ray.direction*tret;
			isect.normal = isect.position - sphere.center;
			isect.normal = normalize(isect.normal);
			return true;			
		}
		return false;
	}
	else
	{
		return false;
	}
}

bool intersectAll(Ray r, inout Intersection isect)
{
	bool hasHit = false;
	const int numSphere = 4;
	Sphere spheres[numSphere];
	
	spheres[0].center = vec3(0.0,0.0-1.0,20.0);	spheres[0].radius = 1.0;	spheres[0].materialId = 0;
	spheres[1].center = vec3(3.0,0.0-1.0,15.0);	spheres[1].radius = 1.0;	spheres[1].materialId = 0;
	spheres[2].center = vec3(-3.0,0.0-1.0,30.0);spheres[2].radius = 1.0;	spheres[2].materialId = 0;
	spheres[3].center = vec3(-2.0,-100000.0-2.0,50.0);spheres[3].radius = 100000.0;	spheres[3].materialId = 0;
	
	
	for(int i=0;i<numSphere;i++)
	{
		if(sphereIntersection(spheres[i], r, isect))
		{
			hasHit = true;
			isect.materialId = spheres[i].materialId;
		}
	}
	
	return hasHit;
}

void pushStack(inout Stack stack, Query x)
{
	int s = stack.stackSize;
	if(s==0)
		stack.q0 = x;
	else if(s==1)
		stack.q1 = x;
	else if(s==2)
		stack.q2 = x;
	else if(s==3)
		stack.q3 = x;
	/*
	else if(s==4)
		stack.q4 = x;
	else if(s==5)
		stack.q5 = x;
	else if(s==6)
		stack.q6 = x;
	else if(s==7)
		stack.q7 = x;
	*/
	if(s<4)stack.stackSize++;
}

Query popStack(inout Stack stack)
{
	
	Query nullRet;	
	nullRet.ray.direction = vec3(1,0,0);
	nullRet.ray.orign = vec3(0,1,0);
	
	if(stack.stackSize==0)
		return nullRet;
		
	stack.stackSize--;
	int s = stack.stackSize;
	
	if(s==0)
		return stack.q0;
	else if(s==1)
		return stack.q1;
	else if(s==2)
		return stack.q2;
	else if(s==3)
		return stack.q3;
	/*
	else if(s==4)
		return stack.q4;
	else if(s==5)
		return stack.q5;
	else if(s==6)
		return stack.q6;
	else if(s==7)
		return stack.q7;*/
	return nullRet;
}

vec3 raytrace(vec2 uv)
{
	
	float aspect = uv.x/uv.y;

	
	vec3 cameraPos = vec3(0.0,0.0,0.0);
	vec3 DL = vec3(-1.0,-1.0,3.0);
	vec3 DL2DR = vec3(2.0,0.0,0.0);
	vec3 DL2UL = vec3(0.0,2.0,0.0);
	vec3 targetPos = DL + uv.x*DL2DR + uv.y*DL2UL;
	

	
	Ray r;
	r.orign = cameraPos;
	r.direction = normalize(targetPos - cameraPos);
	Query query;
	query.ray = r;
	query.coeff = vec3(1);
	query.isInside = false;
	
	Stack stack;
	pushStack(stack, query);
	
	bool onehit = false;
	vec3 sum = vec3(0);
	
	for(int i=0;i<4;i++)
	{
		
		if(stack.stackSize==0) break;//return vec3(1,0,0);	
		Query q = popStack(stack);
		
		Intersection isect;
		isect.time = 10000.0;
		if(/*length(q.coeff)>0.1&&*/intersectAll(q.ray, isect))
		{
			//reflect
			Ray refl;
			refl.direction = reflect(q.ray.direction, isect.normal);
			refl.orign = isect.position + isect.normal*0.01;
			
			Query reflq;
			reflq.ray = refl;
			reflq.coeff = vec3(0.2,0.6,0.7) * q.coeff;
			
			pushStack(stack, reflq);
			
			//refract
			Ray refr;
			refr.direction = refract(q.ray.direction, isect.normal, 1.0);
			//refr.direction = normalize(refr.direction);
			refr.orign = isect.position - isect.normal*0.01;
			
			if(refr.direction!=vec3(0))
			{
				Query refrq;
				refrq.ray = refr;
				refrq.coeff = vec3(0.996) * q.coeff;
				//pushStack(stack, refrq);
				
			}			
		}
		else
		{
			//sum += (q.ray.direction.xzy+1.0)/2.0 * q.coeff;
			sum += q.ray.direction * q.coeff;
		}
		
	
	}
	/*
	Intersection isect;
	isect.time = 100000.0;
	bool hit = intersectAll(r, isect);
	vec3 ret = vec3(0);
	if(hit)
	{
		ret = vec3(dot(isect.normal,normalize(vec3(3,5,2))));//isect.normal;
		ret = vec3(1);
		ret *= fresnel(isect.normal,-r.direction,0.5);
		ret += vec3(0.2,0.3,0.4);
		Ray shadowRay;
		shadowRay.orign = isect.position + isect.normal*0.01;//r.orign + r.direction*(isect.time-0.1);
		shadowRay.direction = normalize(vec3(3,5,2));
		Intersection isect2;
		isect2.time = 10000.0;
		if(intersectAll(shadowRay, isect2))
		{
			ret *= 0.5;
		}
	}
	else
	{
		ret = vec3(0);
	}
	

	return ret;
	*/
	return sum;
}

void main(void)
{
	vec2 uv =  ( gl_FragCoord.xy / resolution.xy );
	vec2 seed = uv;	
	
	vec3 sum = vec3(0.0);
	const int loop = 1;
	for(int i=0;i<loop;i++)
	{	
		vec2 r = rand(seed);
		vec2 uvTmp = uv + r*0.001;
		sum += raytrace(uvTmp);
		seed = r;
	}
	gl_FragColor.xyz =  sum/float(loop);
}