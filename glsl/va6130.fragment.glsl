#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
uniform vec4 mouse;
uniform sampler2D tex0;
uniform sampler2D tex1;

struct SphereIntersection
{
	// IN:
	vec4 sphere;
	vec3 ro;
	vec3 rd;
	// OUT:
	float t;
	vec3 point;
	vec3 normal;
	float depth;
};
	
struct Camera
{
	vec3 position;
	vec3 forward;
};
	
float saturate(float f)
{
	return clamp(f,0.0,1.0);
}

// Theta, Phi (r == 1)
vec2 normalToSpherical(vec3 normal)
{
	vec2 spherical;
	spherical.x = acos(normal.z);
	spherical.y = atan(normal.y/normal.x);
	return spherical;
}

// Input: Radius, Theta, Phi
vec3 sphericalToCartesian(vec3 s)
{
	vec3 cart;
	cart.x = s.x * sin(s.y) + cos(s.z);
	cart.y = s.x * sin(s.y) + sin(s.z);
	cart.z = s.x * cos(s.y);
	return cart;
}

// Ray origin, Ray direction, (Sphere center, Sphere radius)
void raySphere(inout SphereIntersection i)
{
	vec4 sphere = i.sphere;
	vec3 ro = i.ro;
	vec3 rd = i.rd;
	vec3 sc = sphere.xyz;
	float sr = sphere.w;
	vec3 sd = ro-sc;
	// a == 1
	float b = 2.0*dot(rd,sd);
	float c = dot(sd,sd)-(sr*sr);
	float disc = b*b - 4.0*c;
	if(disc<0.0)
	{
		i.t = -1.0;
		return;
	}
	float t = (-b-sqrt(disc))/2.0;
	i.t = t;
	i.point = ro+rd*t;
	i.normal = normalize(i.point-sphere.xyz);
	i.depth = 2.0*sr*dot(normalize(sd),i.normal);
}

vec3 sphereNormal(vec4 sphere, vec3 point)
{
	return normalize(point-sphere.xyz);
}

float sphereFunction(vec2 coord)
{
	return sin(coord.x*10.0)+cos(coord.y*10.0);
}


vec3 sphereFunctionNormal(vec2 coord)
{
	//float ho = sphereFunction(coord);
	float d = 0.00001;
	vec2 s1coord = coord+vec2(d,0);
	float s1 = sphereFunction(s1coord);
	vec2 s2coord = coord+vec2(0,d);
	float s2 = sphereFunction(s2coord);
	vec3 s1c = sphericalToCartesian(vec3(s1,s1coord.x,s1coord.y));
	vec3 s2c = sphericalToCartesian(vec3(s2,s2coord.x,s2coord.y));
	return normalize(cross(s1c,s2c));
}

void rayMarchSphere(inout SphereIntersection i)
{
	const float NUM_SAMPLES = 30.0;
	vec3 pos = i.point;
	vec3 dir = i.rd;
	float stepSize = i.depth/NUM_SAMPLES;
	for(float s = 0.0; s < NUM_SAMPLES; s++)
	{
		vec3 v = pos-i.sphere.xyz;
		float height = length(v);
		vec3 n = v/height;
		vec2 sCoord = normalToSpherical(n);
		float testHeight = sphereFunction(sCoord)*i.sphere.w;
		testHeight += 0.000001; // Prevent floating point error
		if(height<=testHeight)
		{
			i.t = length(pos-i.ro);
			i.point = pos;
			//i.normal = n;
			i.normal = sphereFunctionNormal(sCoord);
			return;
		}
		if(s == 0.0)
		{
			// Jitter
			float random;
			pos += dir*stepSize*saturate(random);
		}
		pos += dir*stepSize;
	}
	// No hit
	i.t = -1.0;
	return;
}

vec3 lighting(vec3 point, vec3 N, vec3 light, vec3 color)
{
	vec3 toLight = light-point;
	vec3 L = normalize(toLight);
	return color*dot(N,L);
}

void main(void)
{
	vec2 screenPos = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
	vec2 screenPosAR = vec2(screenPos.x*(resolution.x/resolution.y),screenPos.y);
	
	vec3 rayDir = normalize(vec3(screenPosAR.x,screenPosAR.y,1.0));
	
	vec3 light = vec3(3,3,3);
	
	vec4 sphere = vec4(sin(time/2.0),cos(time/2.0),3.0,2.0);
	SphereIntersection inter;
	inter.ro = vec3(0,0,0);
	inter.rd = rayDir;
	inter.sphere = sphere;
	raySphere(inter);
	
	SphereIntersection test = inter;
	rayMarchSphere(test);
	
	vec3 color;
	if(inter.t > 0.0 && test.t > 0.0)
	{
		float c = inter.t/7.0;
		//color.xyz = vec3(c,c,c);
		color.xyz = test.normal.xyz;
	}
	else
	{
		//color.xyz = vec3(screenPosAR.x,screenPosAR.y,0);
		color.xyz = vec3(0,0,0);
	}

	gl_FragColor.xyz = color;
	gl_FragColor.w = 1.0;
}