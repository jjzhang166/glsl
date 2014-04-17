#ifdef GL_ES http://glsl.heroku.com/e#9215.0 
precision mediump float;
#endif 

//just some rings hoping to be something more 
//sphinx

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float EPSILON = 0.00005;

struct Camera
{
	vec3 position;
	vec3 dir;
	vec3 up;
	vec3 rayDir;
};

struct MapResult
{
	float dist;
	vec3 color;
};
	
struct MarchResult
{
	vec3 position;
	float dist;
	vec3 color;
};

mat4 rotationMatrix(vec3 axis, float angle)
{
	axis = normalize(axis);
	float s = sin(angle);
	float c = cos(angle);
	float oc = 1.0 - c;
	return mat4(oc * axis.x * axis.x + c, oc * axis.x * axis.y - axis.z * s, oc * axis.z * axis.x + axis.y * s, 0.0,
		    oc * axis.x * axis.y + axis.z * s, oc * axis.y * axis.y + c, oc * axis.y * axis.z - axis.x * s, 0.0,
		    oc * axis.z * axis.x - axis.y * s, oc * axis.y * axis.z + axis.x * s, oc * axis.z * axis.z + c, 0.0,
		    0.0, 0.0, 0.0, 1.0);
}

float softMin(float a, float b, float k);
float softMax(float a, float b, float k);
vec3 opCheapBend(vec3 p, float x, float y);
vec3 opTwist(vec3 p, float x, float y);
vec3 getColor(const in Camera cam, const in vec3 position, const in float dist, const in vec3 color);
MapResult map_torus(vec3 position);
MapResult map(vec3 position);
MarchResult raymarch(const in Camera cam);
Camera getCamera();

void main() 
{	
	Camera cam = getCamera();
	MarchResult result = raymarch(cam);
		
	vec3 color = result.color;
	
	gl_FragColor = vec4(color, 1.0);
}

vec3 opCheapBend(vec3 p, float x, float y)
{
    float c = cos(x*p.y);
    float s = sin(y*p.y);
    mat2  m = mat2(c,-s,s,c);
    vec3  q = vec3(m*p.xy,p.z);
    return q;
}

float softMax(float a, float b, float k)
{
	return log(exp(k*a)+exp(k*b))/k;
}

float softMin(float a, float b, float k)
{
	return -(log(exp(k*-a)+exp(k*-b))/k);
}

MapResult map_torus(vec3 p)
{
	MapResult result;
	
	vec2 m = mouse - .5;
	p += vec3(m.x, -m.y, -1.) * 8.;
	
	float t0 = length(vec2(length(p.xy) - 3.14, p.z))-1.62;
	
	p = p+floor(2.*fract(2. * p))/2.;
	
	float t1 = length(vec2(length(p.xy) - 3.14, p.z))-1.62;
	
	float t = t0;
	
	result.dist = t;
	result.color = normalize(p.xyz)*0.5 + 0.5;
	
	return result;
}

MapResult map(vec3 position)
{
	MapResult result;
	result = map_torus(position);
	return result;
}

vec3 getColor(const in Camera cam, const in vec3 position, const in float dist, const in vec3 color)
{	
	vec3 eps 	= vec3(EPSILON, 0, 0);
	vec3 normal	=normalize(vec3(	
				dist - map(position-eps.xyy).dist,
				dist - map(position-eps.yxy).dist,
				dist - map(position-eps.yyx).dist
				));
	float lambert 	= dot(normal, -cam.rayDir);
	return lambert * color;
}

MarchResult raymarch(const in Camera cam)
{
	MarchResult result;
	result.color 			= vec3(0);
	
	const int MAX_ITERATIONS 	= 64;
	const float MAX_DEPTH 		= 32.0;
	
	float depth 			= 0.0;
	
	MapResult mapping;
	for(int i = 0; i < MAX_ITERATIONS; ++i)
	{
		result.position = cam.position + cam.rayDir * depth;
		mapping = map(result.position);
		
		if(mapping.dist <= EPSILON)
		{
			break;
		}
		
		depth += mapping.dist;
				
		if(depth > MAX_DEPTH)
		{
			break;
		}
	}
	
	result.dist = mapping.dist;
	
	if(depth < MAX_DEPTH)
		result.color = getColor(cam, result.position, result.dist, mapping.color);

	return result;
}
	
Camera getCamera()
{
	Camera cam;
  	cam.dir 	= vec3(0,0,1);
	cam.position 	= vec3(0);
	cam.up 		= vec3(0,1,0);
  	vec3 forward 	= normalize(cam.dir - cam.position);
  	vec3 left 	= cross(forward, cam.up);
 	cam.up 		= cross(left, forward);
 	
	vec3 screenOrigin 	= (cam.position+forward);
	vec2 screenPos 		= 2.0*gl_FragCoord.xy/resolution.xy - 1.0;
 	float screenAspectRatio = resolution.x/resolution.y;
	vec3 screenHit 		= screenOrigin + screenPos.x * left * screenAspectRatio + screenPos.y * cam.up;
  
	cam.rayDir 	= normalize(screenHit-cam.position);
	
	return cam;
}
