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

// fuck minecraft!
// warped by weylandyutani amsterdam 2012
	
// (Kabuto) made this a bit more minecraft-like ;-)
	
#define pi 6.1415
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

vec2 getTunnelCoords(float z) {
	return vec2(cos(z*0.3)*6.0 + cos(z*0.53)*2.0, cos(z*0.2)*3.0);
}

bool ShouldDraw(vec3 voxel)
{	
	vec2 tunnel = getTunnelCoords(voxel.z);
	float tx = voxel.x - tunnel.x;
	float ty = voxel.y - tunnel.y;
	return 1. > random( vec4( voxel.x, voxel.z, voxel.y, 0.3481 ) ) + 10./(1.+tx*tx+ty*ty);
}

//currently returns one of 4 stone types
float getStoneType(vec3 voxel) {
	float s1 = dot(sin(voxel*0.41),cos(voxel*0.2714));
	float s2 = dot(sin(voxel*0.3),cos(voxel*0.1642));
	return mix(sign(s1)*.5+2.5, sign(s2)*.5+.5, step(abs(s1*.2),abs(s2)));
}


void IterateVoxel(inout vec3 voxel, Ray ray, out vec3 hitPoint, out vec3 actual)
{	
	vec3 stp = voxel + step(vec3(0), ray.Direction) - ray.Origin;
	vec3 max = stp / ray.Direction;
	
	if(max.x < min(max.y, max.z)) {
		voxel.x += sign(ray.Direction.x);
		hitPoint = vec3(1,0,0);
		actual = stp.x/ray.Direction.x*ray.Direction + ray.Origin;
	} else if(max.y < max.z) {
		voxel.y += sign(ray.Direction.y);
		hitPoint = vec3(0,1,0);
		actual = stp.y/ray.Direction.y*ray.Direction + ray.Origin;
	} else {
		voxel.z += sign(ray.Direction.z);
		hitPoint = vec3(0,0,1);
		actual = stp.z/ray.Direction.z*ray.Direction + ray.Origin;
	}
}
	
vec4 GetRayColor(Ray ray)
{
	vec3 voxel = ray.Origin - fract(ray.Origin);
	vec3 hitPoint;
	vec3 actual;
	
	for(int i=0;i<50/*CAREFUL WITH THIS!!!*/;i++)
	{
		if(ShouldDraw(voxel))
		{
			const float lightDist = 15.0;
			float lightNum = voxel.z/lightDist+1e-5;
			float lightFrac = fract(lightNum);
			lightNum -= lightFrac;
			float lightZ = lightNum*lightDist;
			vec3 light = vec3(getTunnelCoords(lightZ), lightZ);
			vec3 lv = light-voxel;
			float lvl = length(lv);
			float light2 =( dot( hitPoint, lv )/lvl+1.2) / (lvl*lvl);
			float totallight = light2*(1.-lightFrac);
			
			lightNum += 1.;
			lightZ += lightDist;
			light = vec3(getTunnelCoords(lightZ), lightZ);
			lv = light-voxel;
			lvl = length(lv);
			light2 =( dot( hitPoint, lv )/lvl+1.2) / (lvl*lvl);
			totallight += light2*lightFrac;
			
			vec2 tex = floor(fract(vec2(dot(hitPoint,actual.zxx),dot(hitPoint,actual.yzy)))*16.);
			
			float stone = getStoneType(voxel)+1.;
			vec3 c0 = vec3(0.7+stone*.1,0.7,0.7-stone*.1);
			vec3 c1 = vec3(0.7,0.7,0.7)+vec3(stone-3.5,3.5-stone,-0.3)*step(2.5,stone);
			
			
			float rnd = dot(sin(tex*vec2(3.3-stone*.7,.01+.3*stone)), sin(tex*vec2(3.1+stone,.01+.3*stone)));
			vec3 rndV = max(0.,rnd)*c0+max(0.,-rnd)*c1;
			
			return vec4(1.,.8,time*1e-10+.6+1e-10*time/20.0,1.)*vec4(rndV,1.)*totallight*16.;
			
		}
		
		IterateVoxel(voxel, ray, hitPoint, actual);
	}
	
	return vec4(0.0, 0.0, 0.0, 0.0);
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
	      
	currentRay.Direction = normalize( right * (viewCoord.x + sin(viewCoord.x * 1.5) * 3.0) + up * (viewCoord.y + sin(viewCoord.y * 2.8) * 3.0) + forwards);
}

void main( void ) 
{
	Ray currentRay;
 
	GetCameraRay(vec3(getTunnelCoords(time),time), vec3(0.1, 0.0, time*1.+3.), currentRay);

	//making black "black" instead of alpha black... _gtoledo3
	gl_FragColor = vec4(vec3(GetRayColor(currentRay)),1.0);
}