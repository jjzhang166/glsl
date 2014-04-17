#ifdef GL_ES
precision mediump float;
#endif

struct Ray
{
	vec3 Origin;
	vec3 Direction;
};

bool ShouldDraw(vec3 voxel)
{
	return true;
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
	
	if(maxX <= min(maxY, maxZ))
	{
		voxel.x += sign(ray.Direction.x);
		hitPoint = vec3(1,0,0);
	}
	if(maxY <= min(maxX, maxZ))
	{
		voxel.y += sign(ray.Direction.y);
		hitPoint = vec3(0,1,0);
	}
	if(maxZ <= min(maxX, maxY))
	{
		voxel.z += sign(ray.Direction.z);
		hitPoint = vec3(0,0,1);
	}
}
	
vec4 GetRayColor(Ray ray)
{
	vec3 voxel = ray.Origin - fract(ray.Origin);
	vec3 hitPoint;
	
	for(int i=0;i<128/*CAREFUL WITH THIS!!!*/;i++)
	{
		if(ShouldDraw(voxel))
		{
			if(hitPoint == vec3(1,0,0))
			{
				return vec4(0.4, 0.6, 0.3, 1.0) * 1.0;
			}
			if(hitPoint == vec3(0,1,0))
			{
				return vec4(0.4, 0.6, 0.3, 1.0) * 1.0;
			}
			if(hitPoint == vec3(0,0,1))
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
	
	
	vec2 uV = ( gl_FragCoord.xy / vec2(1920, 1080) );
	vec2 viewCoord = uV * 2.0 - 1.0;
	
	float ratio = 1920.0 / 1080.0;
	
	viewCoord.y /= ratio;                              
	
	currentRay.Origin = position;
	
	vec3 right = normalize(cross(forwards, worldUp));
	vec3 up = cross(right, forwards);
	       
	currentRay.Direction = normalize( right * viewCoord.x + up * viewCoord.y + forwards);
}

void main( void ) 
{
	Ray currentRay;
 
	GetCameraRay(vec3(10.1), vec3(0.1), currentRay);

	gl_FragColor = GetRayColor(currentRay);
}