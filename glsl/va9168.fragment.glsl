#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

struct Camera
{
	vec3 position;
	vec3 dir;
	vec3 up;
	vec3 rayDir;
};

struct Ray
{
	vec3 origin;
	vec3 dir;
};
	
struct Material
{
	vec3 color;	
};
	
struct MarchResult
{
	vec3 position;
	float dist;
	Material material;	
};
	
vec2 getViewCoord()
{
	vec2 uv = (gl_FragCoord.xy / resolution.xy);
	vec2 viewCoord = uv * 2.0 - 1.0;
	float ratio = resolution.x / resolution.y;
	viewCoord.y /= ratio;
	return viewCoord;
}
	
Camera getCamera()
{
	Camera cam;
  	cam.dir = vec3(0,0,0);
	cam.position = vec3(sin(time)*4.0, cos(time)*6.0, cos(time)*4.0);
	cam.up = vec3(0,1,0);
  	vec3 forward = normalize(cam.dir - cam.position);
  	vec3 left = cross(forward, cam.up);
 	cam.up = cross(left, forward);
 
	vec3 screenOrigin = (cam.position+forward);
	vec2 screenPos = 2.0*gl_FragCoord.xy/resolution.xy - 1.0;
 	float screenAspectRatio = resolution.x/resolution.y;
	vec3 screenHit = screenOrigin + screenPos.x * left * screenAspectRatio + screenPos.y * cam.up;
  
	cam.rayDir = normalize(screenHit-cam.position);
	return cam;
}

float map(inout MarchResult result)
{
	Material sphere;
	sphere.color = vec3(1, 0.5, 0.2);
	result.material = sphere;
		
	/*vec2 t = vec2(0.5);
	vec2 q = vec2(length(pos.zx) - t.x, pos.y);
	return length(q) - t.y;*/
	
	return length(max(abs(result.position)-vec3(1.0),0.0))-0.1;
}

float map(const in vec3 position)
{	
	return length(max(abs(position)-vec3(1.0),0.0))-0.1;
}

MarchResult raymarch(const in Camera cam)
{
	MarchResult result;
	
	const int MAX_ITERATIONS = 256;
	const float MAX_DEPTH = 250.0;
	const float EPS = 0.01;
	
	result.position= vec3(0);
	float depth = 0.0;
	for(int i = 0; i < MAX_ITERATIONS; ++i)
	{
		result.position = cam.position + cam.rayDir * depth;
		result.dist = map(result);
		
		if(result.dist <= EPS)
		{
			break;
		}
		
		depth += result.dist;
		
		if(depth > MAX_DEPTH)
		{
			result.material.color = vec3(0.1, 0.3, 0.8);
			break;
		}
	}
	
	
	
	return result;
}

vec3 getColor(const in Camera cam, const in MarchResult result)
{
	vec3 eps = vec3(0.1, 0, 0);
	
	vec3 normal=normalize(
		   vec3(result.dist - map(result.position-eps.xyy),
			result.dist - map(result.position-eps.yxy),
			result.dist - map(result.position-eps.yyx)));

	
	float lambert = dot(normal, -cam.rayDir);
	
	return lambert * result.material.color;
}

void main() 
{	
	Camera cam = getCamera();
	MarchResult result = raymarch(cam);
		
	vec3 color = getColor(cam, result);
	
	gl_FragColor = vec4(color, 1.0);
}