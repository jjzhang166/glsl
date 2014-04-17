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

bool GetVoxel(vec3 voxel)
{
	return voxel.y < 0.0;
}

void IterateVoxel(inout vec3 voxel, Ray ray)
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
		voxel += sign(ray.Direction.x);
	}
	if(maxY < min(maxX, maxZ))
	{
		voxel += sign(ray.Direction.y);
	}
	if(maxZ < min(maxX, maxY))
	{
		voxel += sign(ray.Direction.z);
	}
}
	
vec4 GetRayColor(Ray ray)
{
	vec3 voxel = floor(ray.Origin);
	
	for(int i=0;i<100/*CAREFUL WITH THIS!!!*/;i++)
	{
		if(GetVoxel(voxel))
		{
			return vec4(0.0, 0.0, 0.0, 1.0);
		}
		
		IterateVoxel(voxel, ray);
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
 
	GetCameraRay(vec3(1.0, 1.0, 1.0), vec3(0.0, 0.0, 0.0), currentRay);

	gl_FragColor = GetRayColor(currentRay);
}