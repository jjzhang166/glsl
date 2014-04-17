#ifdef GL_ES
precision highp float;
#endif

#define pi 3.1415

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

struct Ray
{
	vec3 Origin;
	vec3 Direction;
};
	
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
	
	
float Box(vec3 p, vec3 b) 
{	
	b = b / 2.0;
	return length(max(abs(p)-b,0.0));
}

float maxcomp( vec3 vec )
{
  	return max(vec.x, max(vec.y, vec.z));
}

float HeightFunction(vec3 position)
{
	return position.y - (floor(getBilerp(floor(position.xz), vec2(64), 41.04, true) * 20.0) - 10.0);
	//return position.y - 0.0;
	//return position.y - sin(length(position.xz));
}

bool ShouldDraw(vec3 position)
{
	return HeightFunction(position) < 0.0;
}

float GetShortestDistance(const in vec3 position, out vec3 color)
{
	float padding = 1.0;
	vec3 repeatPosition;
	repeatPosition = mod(position, vec3(padding)) -0.5 * padding;
	
	// plain color
	color = vec3(0.4, 0.6, 0.3);
	
	// center glow
	//color *= max(1.0 - abs(repeatPosition.z) + abs(repeatPosition.x), 0.5);
	
	//checkerboard
	//color *= (mod(floor(position).x + floor(position).y + floor(position).z, 2.0) * 0.2 + 0.8);
	
	
	// face shading
	vec3 fractPos = abs(fract(position));
	
	if(fractPos.x > fractPos.y && fractPos.x > fractPos.z)
	{
		color *= 0.6;
	}
	else if(fractPos.z > fractPos.y && fractPos.z > fractPos.x)
	{
		color *= 0.8;
	}
 
	if(ShouldDraw(position))
	{
		return Box(repeatPosition, vec3(1.0));
	}
	else
	{
		color = vec3(0.39, 0.58, 0.93);
		return 0.1;
	}
	
}

vec4 GetRayColor(const in Ray currentRay)
{	
	vec3 currentStep;
	float currentDist;
	vec3 color;
	for(int i = 0; i <= 500; i++)                  
	{
		currentStep = currentRay.Origin + currentRay.Direction * currentDist;   
		
		float sceneDist = GetShortestDistance( currentStep, color );
		currentDist += sceneDist;

	}
	return vec4(color, 1.0);
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
	
	GetCameraRay(vec3(-time*10.0, 10.0, -time*10.0), vec3(-time*10.0 - 10.0*cos(mouse.x/resolution.x*1000.0), 7.0*sin(mouse.y/resolution.y * 1000.0), -time*10.0 - 10.0*sin(mouse.x/resolution.x*1000.0)), currentRay);

	gl_FragColor = GetRayColor(currentRay);

}