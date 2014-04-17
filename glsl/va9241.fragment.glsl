#ifdef GL_ES
precision mediump float;
#endif

// original code here: http://glsl.heroku.com/e#9168.0
// extended it with a very simple subpixel rendering
// results are too faint to make the 3x raymarching worth the cost :/

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
	
Camera getCamera(const in vec2 offset)
{
	Camera cam;
  	cam.dir = vec3(0,0,0);
	cam.position = vec3(sin(time * 0.1)*4.0, cos(time * 0.1)*1.0, cos(time * 0.1)*4.0);
	cam.up = vec3(0,1,0);
  	vec3 forward = normalize(cam.dir - cam.position);
  	vec3 left = cross(forward, cam.up);
 	cam.up = cross(left, forward);
 
	vec3 screenOrigin = (cam.position+forward);
	vec2 screenPos = 2.0*(gl_FragCoord.xy + offset)/resolution.xy - 1.0;
 	float screenAspectRatio = resolution.x/resolution.y;
	vec3 screenHit = screenOrigin + screenPos.x * left * screenAspectRatio + screenPos.y * cam.up;
  
	cam.rayDir = normalize(screenHit-cam.position);
	return cam;
}

float map(inout MarchResult result)
{
	Material sphere;
	sphere.color = vec3(sin(time * 0.2 + 0.7), sin(time * 0.3 + 0.4), sin(time * 0.4 + 0.1)); //vec3(1.0, 0.5, 0.2);
	result.material = sphere;

	return length(max(abs(result.position)-vec3(1.0),0.0))-0.1;
}

float map(const in vec3 position)
{	
	return length(max(abs(position)-vec3(1.0),0.0))-0.1;
}

MarchResult raymarch(const in Camera cam)
{
	MarchResult result;
	
	const int MAX_ITERATIONS = 64;
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
		if (result.dist > MAX_DEPTH)
			break;	
	}
	
	
	
	return result;
}

vec3 getColor(const in Camera cam, const in MarchResult result)
{
	vec3 backgroundColor = vec3(0.3, 0.6, 1.0);
	if (result.dist > 1.0) {
		return backgroundColor;
	}

	vec3 eps = vec3(0.1, 0, 0);
	
	vec3 normal=normalize(
		   vec3(result.dist - map(result.position-eps.xyy),
			result.dist - map(result.position-eps.yxy),
			result.dist - map(result.position-eps.yyx)));
	
	float lambert = dot(normal, -cam.rayDir) + 0.5;
	
	return lambert * result.material.color;
}

void main() 
{	
	vec2 subpixel = vec2(1.0/3.0, 0.0);
	Camera cam_r = getCamera(-subpixel);
	Camera cam_g = getCamera(vec2(0.0));
	Camera cam_b = getCamera(+subpixel);

	if (gl_FragCoord.y < resolution.y * 0.5) {
		cam_r = cam_g;
		cam_b = cam_g;
	}

	MarchResult result_r = raymarch(cam_r);
	MarchResult result_g = raymarch(cam_g);
	MarchResult result_b = raymarch(cam_b);

	gl_FragColor.a = 1.0;
	gl_FragColor.rgb = (getColor(cam_r, result_r) + getColor(cam_g, result_g) + getColor(cam_b, result_b)) / 3.0;

	if (abs(gl_FragCoord.y - resolution.y * 0.5) < 1.0) {
		gl_FragColor.rgb = vec3(0.0);
	}
}