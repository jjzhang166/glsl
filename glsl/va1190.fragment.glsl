#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

struct Ray
{
	vec3 Origin;
	vec3 Direction;
};
	
struct HitInfo
{
	float Distance;
	vec3 Position;
};

float Box(vec3 p, vec3 b) 
{	
	b = b / 2.0;
	return length(max(abs(p)-b,0.0));
}

bool ShouldDraw(vec3 position)
{
	return length(position) < 10.0;
}

float GetSceneDistance(const in vec3 position, out float height)
{
	float padding = 2.0;
	vec3 repeatPosition;
	repeatPosition = mod(position, vec3(padding)) -0.5 * padding;
	
	
	if(ShouldDraw(position))
	{
		height = 1.0 - (abs(repeatPosition.z) + abs(repeatPosition.x));
		return Box(repeatPosition, vec3(1.0));
	}
	else
	{
		height = 0.0;
		return 1.0;
	}	
}

vec4 GetRayColor(const in Ray currentRay)
{	
	HitInfo result;
	float height;
	for(int i = 0; i <= 250; i++)                  
	{
		result.Position = currentRay.Origin + currentRay.Direction * result.Distance;   
		
		result.Distance = result.Distance + GetSceneDistance( result.Position, height );  
	}
	return vec4(vec3(height), 1.0);
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
	
	GetCameraRay(vec3(sin(time)*100.0, 5.0, cos(time) * 100.0), vec3(0.0, 0.0, 0.0), currentRay);

	gl_FragColor = GetRayColor(currentRay);

}