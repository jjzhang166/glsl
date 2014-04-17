// Ray tracing with improvised volumetric shadows
// Should mostly work on Windows. Still a weird reflection of the floor going on ...
// Matthijs De Smedt
// @anji_nl

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float ZMAX = 99999.0;
const float EPSILON = 0.001;
const int MAX_BOUNCES = 3;
const int VOLUMETRIC_SAMPLES = 10;

struct Intersection
{
	vec3 p;
	float dist;
	
	vec3 n;
	vec3 diffuse;
	vec3 specular;
};
	
struct Ray
{
	vec3 o;
	vec3 dir;
};
	
struct Light
{
	vec3 p;
	vec3 color;
	float radius;
};
	
struct Plane
{
	vec3 n;
	float d;
};
	
struct Sphere
{
	vec3 c;
	float r;
};

float saturate(float f)
{
	return clamp(f,0.0,1.0);
}

vec3 saturate(vec3 v)
{
	return clamp(v,vec3(0,0,0),vec3(1,1,1));
}

float rand(vec2 co)
{
	return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453 + time);
}

Intersection RaySphere(Ray ray, Sphere sphere)
{
	Intersection i;
	vec3  d = ray.o - sphere.c;
	float b = dot(ray.dir, d);
	float c = dot(d, d) - (sphere.r*sphere.r);
	float t = b*b - c;
	
	// ANGLE bug work-around?
	if(t > 0.0)
	{
		t = -b - sqrt( t );
	}
	
	if(t > EPSILON)
	{
		i.p = ray.o + ray.dir * t;
		i.n = normalize(i.p-sphere.c);
		i.dist = t;
	}
	else
	{
		i.dist = ZMAX;
	}
	return i;
}

Intersection RayPlane(Ray ray, Plane p)
{
	Intersection i;
	float num = p.d-dot(p.n, ray.o);
	float denom = dot(p.n, ray.dir);
	float t = num/denom;
	if(t > EPSILON)
	{
		i.p = ray.o + ray.dir * t;
		i.n = p.n;
		i.dist = t;
	}
	else
	{
		i.dist = ZMAX;
	}
	return i;
}

Intersection MinIntersection(Intersection a, Intersection b)
{
	if(a.dist < b.dist)
	{
		return a;
	}
	else
	{
		return b;
	}
}

vec3 PlaneMaterial(Intersection i)
{
	float d = 0.0;
	d = mod(floor(i.p.x)+floor(i.p.z),2.0);
	return vec3(d,d,d)*0.8;
}

Intersection SceneIntersection(Ray r)
{
	Intersection iOut;
	
	Plane plane;
	plane.n = normalize(vec3(0,1,0));
	plane.d = -2.0;
	Intersection iPlane = RayPlane(r, plane);
	iPlane.diffuse = PlaneMaterial(iPlane);
	iPlane.specular = vec3(1,1,1)-iPlane.diffuse;
	iOut = iPlane;
	
	/*
	Plane planeB;
	planeB.n = normalize(vec3(1,0.0,0.0));
	planeB.d = -4.0;
	Intersection iPlaneB = RayPlane(r, planeB);
	iPlaneB.diffuse = vec3(0.4,0.0,0.0);
	iPlaneB.specular = vec3(0.4,0,0.0);
	iOut = MinIntersection(iOut, iPlaneB);
	
	Plane planeC;
	planeC.n = normalize(vec3(-1,0.0,0.0));
	planeC.d = -4.0;
	Intersection iPlaneC = RayPlane(r, planeC);
	iPlaneC.diffuse = vec3(0.0,0.0,0.4);
	iPlaneC.specular = vec3(0.0,0.0,0.4);
	iOut = MinIntersection(iOut, iPlaneC);
	*/
	
	
	for(int s = 0; s <= 3; s++)
	{
		float fs = float(s);
		float t = time*0.3+fs*2.0;
		vec3 pos;
		pos.x = sin(t*2.0)*2.0+sin(t*2.0)*3.0;
		pos.y = abs(sin(t))*2.0;
		pos.z = 6.0+cos(t)*2.0+cos(t*1.5)*2.0;
		Sphere sphere;
		sphere.c = pos;
		sphere.r = 2.0;
		Intersection iSphere = RaySphere(r, sphere);
		iSphere.diffuse = vec3(0.0,0.0,0.2);
		iSphere.specular = vec3(0.2,0.2,0.6);
		iOut = MinIntersection(iOut, iSphere);
	}

	/*
	Sphere sphere;
	sphere.c = vec3(0,0,0);
	sphere.r = 1.0;
	Intersection iSphere = RaySphere(r, sphere);
	iSphere.diffuse = vec3(0.0,0.0,0.2);
	iSphere.specular = vec3(0.2,0.2,0.6);
	iOut = MinIntersection(iOut, iSphere);
	*/
	
	return iOut;
}

vec3 CalcIrradiance(Light light, vec3 p)
{
	float distA = 1.0-saturate(length(light.p-p)/light.radius);
	return distA * light.color;
}

vec3 CalcLighting(Light light, Intersection i, vec3 origin)
{
	vec3 n = i.n;
	vec3 p = i.p;
	vec3 l = normalize(light.p-p);
	vec3 v = normalize(origin-p);
	vec3 h = normalize(l+v);
	float NdotL = saturate(dot(n,l));
	float NdotH = saturate(dot(n,h));
	vec3 diffuse = NdotL*i.diffuse;
	vec3 spec = pow(NdotH,8.0) * i.specular;
	float distA = 1.0-saturate(length(light.p-p)/light.radius);
	vec3 color;
	color = (diffuse+spec) * distA * light.color;
	
	float shadow = 1.0;
	Ray shadowRay;
	float lightDist = length(light.p-i.p);
	shadowRay.dir = (light.p-i.p)/lightDist;
	shadowRay.o = i.p + shadowRay.dir*EPSILON;
	Intersection shadowI = SceneIntersection(shadowRay);
	if(shadowI.dist < lightDist)
	{
		shadow = 0.0;
	}
	color *= shadow;
	
	return color;
}

vec3 GetLighting(Intersection i, vec3 origin)
{
	vec3 color = vec3(0,0,0);
	Light light;
	
	light.p = vec3(sin(time*0.3)*2.0,5,cos(time*0.3)*2.0+4.0);
	light.color = vec3(1,1,1);
	light.radius = 20.0;
	color += CalcLighting(light, i, origin);
	
	/*
	light.p = vec3(cos(time*0.2)*2.0,5,sin(time*0.2)*2.0+8.0);
	light.color = vec3(1,1,1);
	light.radius = 20.0;
	color += CalcLighting(light, i, origin);
	*/
	
	return color;
}

vec3 GetVolumetricLighting(Ray ray, float maxDist)
{
	vec3 color = vec3(0,0,0);
	Light light;
	light.p = vec3(sin(time*0.3)*2.0,5,cos(time*0.3)*2.0+4.0);
	light.color = vec3(1,1,1);
	light.radius = 20.0;
	
	float inscattering = maxDist/200.0;
	float volRayStep = maxDist/float(VOLUMETRIC_SAMPLES-1);
	float randomStep = rand(gl_FragCoord.xy)*volRayStep;
	Ray volRay;
	volRay.o = ray.o + ray.dir*randomStep;
	for(int v = 0; v < VOLUMETRIC_SAMPLES; v++)
	{
		vec3 lightVec = light.p-volRay.o;
		float lightDist = length(lightVec);
		volRay.dir = lightVec/lightDist;
		Intersection i = SceneIntersection(volRay);
		if(i.dist > lightDist)
		{
			color += CalcIrradiance(light, volRay.o)*inscattering;
		}
		volRay.o += ray.dir * volRayStep;
	}
	
	return color;
}

vec3 GetColor(Ray ray)
{
	vec3 color = vec3(0,0,0);
	vec3 volumetric = vec3(0,0,0);
	vec3 prevSpecular = vec3(1.0,1.0,1.0);
	for(int r = 0; r <= MAX_BOUNCES; r++)
	{
		Intersection i;
		// Find intersection
		i = SceneIntersection(ray);
		if(r == 0)
		{
			volumetric = GetVolumetricLighting(ray, min(i.dist, 20.0));
		}
		if(i.dist > ZMAX-EPSILON)
		{
			break;
		}
		// Blend color
		vec3 diffuse = GetLighting(i, ray.o);
		color += diffuse * prevSpecular;
		prevSpecular *= i.specular;
		// Calculate next ray
		vec3 incident = normalize(i.p-ray.o);
		ray.dir = reflect(incident,i.n);
		ray.o = i.p+ray.dir*EPSILON;
	}
	color -= volumetric*0.5;
	color += volumetric;
	return color;
}

void main( void )
{
	vec2 pos = -1.0 + 2.0 * ( gl_FragCoord.xy / resolution.xy );
	vec2 posAR;
	posAR.x = pos.x * (resolution.x/resolution.y);
	posAR.y = pos.y;
	vec3 rayDir = normalize(vec3(posAR.x, posAR.y, 1.0));
	Ray ray;
	ray.o = vec3(sin(time*0.2),0,0);
	ray.dir = rayDir;

	/*
	vec2 q = gl_FragCoord.xy / resolution.xy;
	vec2 p = -1.0 + 2.0*q;
	p *= vec2(resolution.x/resolution.y,1.0);
	float an = .05*time - 6.2831*mouse.x/resolution.x;
	float di = 2.0+3.0*mouse.y/resolution.y;
	vec2 sc = vec2(cos(an),sin(an));
	vec3 rd = normalize(vec3(p.x*sc.x-sc.y,p.y,sc.x+p.x*sc.y));
	vec3 ro = vec3(di*sc.y,0.0,-di*sc.x);
	Ray ray;
	ray.o = ro;
	ray.dir = rd;
*/
	
	vec3 color = GetColor(ray);
	
	gl_FragColor = vec4(color.x, color.y, color.z, 1.0 );
}