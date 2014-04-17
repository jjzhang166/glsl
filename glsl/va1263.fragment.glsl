#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

struct Ray
{
	vec3 Origin;
	vec3 Direction;
};
	
	
#define pi 3.1415
//Landscape
	
float random(vec4 seed)
{
 	return fract(sin(dot(seed.xy ,vec2(12.9898,78.233)) + dot(seed.zw ,vec2(15.2472,93.2541))) * 43758.5453);
}

float floorTo(float value, float factor)
{
 	return floor(value / factor) * factor;
}

vec2 floorTo(vec2 value, vec2 factor)
{
 	return vec2(floorTo(value.x, factor.x), floorTo(value.y, factor.y));
}

float lerp(float x, float X, float amount, bool usecos)
{
	 if(usecos)
	 {
	  	return x + (X - x) * ((cos(amount * pi) - 1.0 ) / -2.0);
	 }
	 else
	 {
	  	return x + (X - x) * amount;
	 }
}

float bilerp(float xy, float Xy, float xY, float XY, vec2 amount, bool usecos)
{
 	float x = lerp(xy, xY, amount.y, usecos);
 	float X = lerp(Xy, XY, amount.y, usecos);
	return lerp(x, X, amount.x, usecos);
}

float getBilerp(vec2 position, vec2 size, float seed, bool usecos)
{
 	vec2 min = floorTo(position, size);
 	vec2 max = min + size;
 
 	return bilerp(random(vec4(min.x, min.y, seed, seed)),
   		random(vec4(max.x, min.y, seed, seed)),
   		random(vec4(min.x, max.y, seed, seed)),
   		random(vec4(max.x, max.y, seed, seed)),
   		(position - min) / size, usecos);
}

bool ShouldDraw(vec3 voxel)
{
	return length(voxel + vec3(0.5)) <= 8.0;
}

void IterateVoxel(inout vec3 voxel, Ray ray, out vec3 hitPoint)
{
	float maxX = 0.0;
	float maxY = 0.0;
	float maxZ = 0.0;
	
		
	if(ray.Direction.x != 0.0)
	{
		maxX = max((voxel.x - ray.Origin.x) / ray.Direction.x, (voxel.x + 1.0 - ray.Origin.x) / ray.Direction.x);
	}
	if(ray.Direction.y != 0.0)
	{
		maxY = max((voxel.y - ray.Origin.y) / ray.Direction.y, (voxel.y + 1.0 - ray.Origin.y) / ray.Direction.y);
	}
	if(ray.Direction.z != 0.0)
	{
		maxZ = max((voxel.z - ray.Origin.z) / ray.Direction.z, (voxel.z + 1.0 - ray.Origin.z) / ray.Direction.z);
	}
	
	if(maxX < min(maxY, maxZ))
	{
		voxel.x += sign(ray.Direction.x);
		hitPoint = ray.Direction * maxX + ray.Origin - voxel;
	}
	if(maxY < min(maxX, maxZ))
	{
		voxel.y += sign(ray.Direction.y);
		hitPoint = ray.Direction * maxY + ray.Origin - voxel;
	}
	if(maxZ < min(maxX, maxY))
	{
		voxel.z += sign(ray.Direction.z);
		hitPoint = ray.Direction * maxZ + ray.Origin - voxel;
	}
}
	
vec4 GetRayColor(Ray ray)
{
	vec3 voxel = ray.Origin - fract(ray.Origin);
	vec3 hitPoint;
	
	for(int i=0;i<100/*CAREFUL WITH THIS!!!*/;i++)
	{
		if(ShouldDraw(voxel))
		{
			if(fract(hitPoint.x) < min(fract(hitPoint.y), fract(hitPoint.z)))
			{
				return vec4(0.4, 0.6, 0.3, 1.0) * 1.0;
			}
			if(fract(hitPoint.y) < min(fract(hitPoint.x), fract(hitPoint.z)))
			{
				return vec4(0.4, 0.6, 0.3, 1.0) * 1.1;
			}
			if(fract(hitPoint.z) < min(fract(hitPoint.x), fract(hitPoint.y)))
			{
				return vec4(0.4, 0.6, 0.3, 1.0) * 0.8;
			}
		}
		
		IterateVoxel(voxel, ray, hitPoint);
	}
	
	return vec4(0.39, 0.58, 0.93, 1.0);
}

void GetCameraRay(const in vec3 position, const in vec3 lookAt, out Ray currentRay)
{
	vec3 forwards = normalize(lookAt - position);
	vec3 worldUp = vec3(0.0, 1.0, 0.0);
	
	
	vec2 uV = ( gl_FragCoord.xy / resolution.xy );
	vec2 viewCoord = uV * 2.0 - 1.0;
	
	float ratio = resolution.x / resolution.y;
	
	viewCoord.y /= ratio;                              
	
	currentRay.Origin = position;
	
	vec3 right = normalize(cross(forwards, worldUp));
	vec3 up = cross(right, forwards);
	       
	currentRay.Direction = normalize( right * viewCoord.x + up * viewCoord.y + forwards);
}

void main( void ) 
{
	Ray currentRay;
 
	GetCameraRay(vec3(10.1*sin(time), 15.1, 10.1*cos(time)), vec3(0.0, 0.0, 0.0), currentRay);

	gl_FragColor = GetRayColor(currentRay);
}