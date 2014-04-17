#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float EPSILON = 0.001;
const float PI = 3.14159265359;
const float INV_PI = 1.0 / PI;
const float INV_2PI = 1.0 / (2.0 * PI);

const float FAR = 1000.0;
const float NEAR = 0.1;

const vec3 Ambient = vec3(0.5, 0.1, 0.15);
const vec3 SkyColor = vec3(0.06, 0.28, 0.73);
const vec3 HorizonColor = vec3(0.63, 0.14, 0.04);
const float SkyDistance = 1000.0;

vec2 AspectRatio = vec2(resolution.x / resolution.y, 1.0);

const float Fov = 90.0;
const float halfFovRad = Fov * 0.5 * PI / 180.0;
const float f = -FAR / (FAR - NEAR);
const float f2 = f * NEAR;
float S = 1.0 / tan(halfFovRad);
mat4 ProjectionMat = mat4(S,   0.0,  0.0,  0.0,
		          0.0,  S,   0.0,  0.0,
		          0.0, 0.0,   f,  -1.0,
		          0.0, 0.0,   f,   0.0);

const mat4 TexScaleBiasMat = mat4(0.5, 0.0, 0.0, 0.5,
		             	  0.0, 0.5, 0.0, 0.5,
			    	  0.0, 0.0, 0.5, 0.5,
			    	  0.0, 0.0, 0.0, 1.0);

// Classic Perlin noise
float cnoise(vec2 P);

// Classic Perlin noise, periodic variant
float pnoise(vec2 P, vec2 rep);

struct Sphere
{
	vec3 center;
	float radius;
	vec3 diffuse;
};
	
struct Plane
{
	vec3 normal;
	vec3 point;
	vec3 diffuse;
};

struct Ray
{
	vec3 origin;
	vec3 dir;
};
	
float intersectSphere(Sphere s, Ray r)
{
	vec3 v = r.origin - s.center;
	float a = dot(r.dir, r.dir);
	float b = dot(2.0 * v, r.dir);
	float c = dot(v, v) - s.radius * s.radius;
	
	float disc = b*b - 4.0*a*c;
	if (disc < 0.0)
		return -1.0;
	
	float temp = sqrt(disc) / 2.0*a;
	float t1 = -b - temp;
 	float t2 = -b + temp;
	if (t1 < 0.0) return t2;
	else if (t2 < 0.0) return t1;
	return min(t1, t2);
}

float intersectPlane(Plane p, Ray r)
{
	return -r.origin.y / r.dir.y;
	/*float NdotD = dot(p.normal, r.dir);
	if (NdotD == 0.0)
		return -1.0;
	
	return dot(p.normal, p.point - r.origin) / NdotD;*/
}

vec2 sphereTexCoords(Sphere sphere, vec3 vp)
{	
	//convert point in sphere to spherical coords 
	//has some stretching over the "edges"
	return vec2(atan(vp.x, vp.z), atan(vp.y, sqrt(vp.x*vp.x + vp.z*vp.z)));
}

vec2 projectiveTexCoords(vec3 vp)
{
	//object linear projective texture mapping (see http://goo.gl/ZNQFv)
	vec4 projTC = (ProjectionMat * TexScaleBiasMat) * vec4(vp, 1.0);
	return vec2(projTC.xy / projTC.z);
}

vec2 planeTexCoords(vec3 point, vec2 tileSize)
{
	return vec2(mod(point.x, tileSize.x) / tileSize.x, mod(point.z, tileSize.y) / tileSize.y);
}

vec3 procTex(vec2 uv)
{
	float tolerance = 0.333;
	float p = 0.4;
	float f = uv.y / pow(uv.x, 3.0);
	float t = smoothstep(0.5 - p - tolerance, 0.5 - p + tolerance, f) -
		smoothstep(0.5 + p - tolerance, 0.5 + p + tolerance, f);
		
	return vec3(mix( vec3(1.0), vec3(0.2, 0.6, 0.3), t ));
}

float noise(vec2 p)
{
	return cnoise(p);
}

float sumNoise(vec2 p)
{
	float f = 0.0;
	for (float i=0.0; i < 8.0; i++) 
	{
		float w = pow(2.0, i);
		f +=  cnoise(p * w) / w;
	}
	return f;
}

float sumAbsNoise(vec2 p)
{
	float f = 0.0;
	for (float i=0.0; i < 8.0; i++) 
	{
		float w = pow(2.0, i);
		f +=  abs(cnoise(p * w)) / w;
	}
	return f;
}

float sinSumAbsNoise(float x, vec2 p)
{
	return sin(x + sumAbsNoise(p));
}

vec3 skyColor(vec3 origin, vec3 skyPoint, vec3 sunPos, float timeOfDay)
{
	vec3 skyDir = normalize(skyPoint - origin);
	vec3 sunDir = normalize(sunPos - origin);
	float sunDot = dot(skyDir, sunDir);
	
	vec3 rays = vec3(0.7 * pow(max(0.0, sunDot), 60.0));
	vec3 light = vec3(0.8 * pow(max(0.001, sunDot), 300.0));
	float curve = 1.0 - pow(1.0 - max(skyDir.y, 0.1), 10.0); //sqrt(skyDir.y); //0.25 * (2.0 - sunPos.y);
	vec3 sky = mix(HorizonColor, SkyColor, curve);
	//sky = sky * (1.0 + sunDot) - SkyColor * sunDot;
	//sky *= (1.0 - (1.0 - timeOfDay));
	//sky *= clamp(sunPos.y + 2.0, 0.0, 1.0);
	return sky + light + rays;
}

vec3 shade(vec3 diffuseColor, vec3 normal, vec3 lightDir, float shadow)
{
	float NdotL = max(dot(normal, lightDir), 0.0);
	return diffuseColor * (NdotL * shadow + Ambient);
}

void main() 
{
	vec3 color = vec3(0.0);
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	Ray ray = Ray(vec3(0.0, 1.0, 0.5), normalize(vec3((2.0 * uv - 1.0) * AspectRatio, 1.0)));
	Sphere sphere = Sphere(vec3(0.0, 2.0, 5.0), 1.5, vec3(0.8, 0.2, 0.1));
	Plane plane = Plane(vec3(0.0, 1.0, 0.0), vec3(0.0, -1.0, 0.0), vec3(0.7));
	vec3 lightPos = FAR * normalize(vec3(1.0, 1.0/*(1.0 + sin(0.5 * time)) * 0.5*/, 1.0));// * vec3(cos(time), 1.0, sin(time));
	
	float t = 1000.0;
	float ts = intersectSphere(sphere, ray);
	float tp = intersectPlane(plane, ray);
	int id = -1;
	if (ts > 0.0) {
		t = ts;
		id = 0;
	}
	if (tp > 0.0 && tp < t) {
		t = tp;
		id = 1;
	}
	
	if (id == 0) //sphere
	{
		vec3 point = ray.origin + t * ray.dir;
		vec3 vp = point - sphere.center;
		vec3 normal = normalize(vp);
		vec3 lightDir = normalize(lightPos - point);
		float shadow = max(dot(normal, lightDir), 0.2);
		vec2 uv = projectiveTexCoords(vp); //sphereTexCoords(sphere, vp);		
		color = shade(sphere.diffuse * (4.0 * sumAbsNoise(4.0 * uv)) + (0.6 * sinSumAbsNoise(point.y*point.x, 20.0 * uv)), 
			normal, lightDir, shadow);
	}
	else if (id == 1) //plane
	{
		vec3 point = ray.origin + t * ray.dir;
		vec3 vecToLight = lightPos - point;
		float distToLight = length(vecToLight);
		vec3 lightDir = normalize(vecToLight);
		
		//shadow
		Ray rayToLight = Ray(point + lightDir * EPSILON, lightDir);
		ts = intersectSphere(sphere, rayToLight);
		float shadow = 1.0;
		if (ts > 0.0) {
			shadow = 1.0 - ts / (0.5 + 0.5*ts + 0.5*ts*ts);
		}
		vec3 vecToSphere = sphere.center - point;
		float distToSphere = length(vecToSphere);
		shadow *= smoothstep(0.0, 4.5, distToSphere); // * dot(lightDir, normalize(vecToSphere));
		
		//vec2 tileSize = AspectRatio * 2.0;
		//vec2 uv = planeTexCoords(point, tileSize);
		color = shade(plane.diffuse, // * sinSumAbsNoise(15.0 * uv.x, point.xz), 
			plane.normal, lightDir, shadow);
	}
	else //sky 
	{
		//float height = ray.dir.y;
		//color = mix(HorizonColor, SkyColor, sqrt(height));
		vec3 skyPoint = ray.origin + SkyDistance * ray.dir;
		float timeOfDay = (1.0 + sin(time)) * 0.5;
		color = skyColor(ray.origin, skyPoint, lightPos, timeOfDay);
	}
	gl_FragColor = vec4( color, 1.0 );
}

//
// GLSL textureless classic 2D noise "cnoise",
// with an RSL-style periodic variant "pnoise".
// Author:  Stefan Gustavson (stefan.gustavson@liu.se)
// Version: 2011-08-22
//
// Many thanks to Ian McEwan of Ashima Arts for the
// ideas for permutation and gradient selection.
//
// Copyright (c) 2011 Stefan Gustavson. All rights reserved.
// Distributed under the MIT license. See LICENSE file.
// https://github.com/ashima/webgl-noise
//

vec4 mod289(vec4 x)
{
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec4 permute(vec4 x)
{
  return mod289(((x*34.0)+1.0)*x);
}

vec4 taylorInvSqrt(vec4 r)
{
  return 1.79284291400159 - 0.85373472095314 * r;
}

vec2 fade(vec2 t) {
  return t*t*t*(t*(t*6.0-15.0)+10.0);
}

// Classic Perlin noise
float cnoise(vec2 P)
{
  vec4 Pi = floor(P.xyxy) + vec4(0.0, 0.0, 1.0, 1.0);
  vec4 Pf = fract(P.xyxy) - vec4(0.0, 0.0, 1.0, 1.0);
  Pi = mod289(Pi); // To avoid truncation effects in permutation
  vec4 ix = Pi.xzxz;
  vec4 iy = Pi.yyww;
  vec4 fx = Pf.xzxz;
  vec4 fy = Pf.yyww;

  vec4 i = permute(permute(ix) + iy);

  vec4 gx = fract(i * (1.0 / 41.0)) * 2.0 - 1.0 ;
  vec4 gy = abs(gx) - 0.5 ;
  vec4 tx = floor(gx + 0.5);
  gx = gx - tx;

  vec2 g00 = vec2(gx.x,gy.x);
  vec2 g10 = vec2(gx.y,gy.y);
  vec2 g01 = vec2(gx.z,gy.z);
  vec2 g11 = vec2(gx.w,gy.w);

  vec4 norm = taylorInvSqrt(vec4(dot(g00, g00), dot(g01, g01), dot(g10, g10), dot(g11, g11)));
  g00 *= norm.x;  
  g01 *= norm.y;  
  g10 *= norm.z;  
  g11 *= norm.w;  

  float n00 = dot(g00, vec2(fx.x, fy.x));
  float n10 = dot(g10, vec2(fx.y, fy.y));
  float n01 = dot(g01, vec2(fx.z, fy.z));
  float n11 = dot(g11, vec2(fx.w, fy.w));

  vec2 fade_xy = fade(Pf.xy);
  vec2 n_x = mix(vec2(n00, n01), vec2(n10, n11), fade_xy.x);
  float n_xy = mix(n_x.x, n_x.y, fade_xy.y);
  return 2.3 * n_xy;
}

// Classic Perlin noise, periodic variant
float pnoise(vec2 P, vec2 rep)
{
  vec4 Pi = floor(P.xyxy) + vec4(0.0, 0.0, 1.0, 1.0);
  vec4 Pf = fract(P.xyxy) - vec4(0.0, 0.0, 1.0, 1.0);
  Pi = mod(Pi, rep.xyxy); // To create noise with explicit period
  Pi = mod289(Pi);        // To avoid truncation effects in permutation
  vec4 ix = Pi.xzxz;
  vec4 iy = Pi.yyww;
  vec4 fx = Pf.xzxz;
  vec4 fy = Pf.yyww;

  vec4 i = permute(permute(ix) + iy);

  vec4 gx = fract(i * (1.0 / 41.0)) * 2.0 - 1.0 ;
  vec4 gy = abs(gx) - 0.5 ;
  vec4 tx = floor(gx + 0.5);
  gx = gx - tx;

  vec2 g00 = vec2(gx.x,gy.x);
  vec2 g10 = vec2(gx.y,gy.y);
  vec2 g01 = vec2(gx.z,gy.z);
  vec2 g11 = vec2(gx.w,gy.w);

  vec4 norm = taylorInvSqrt(vec4(dot(g00, g00), dot(g01, g01), dot(g10, g10), dot(g11, g11)));
  g00 *= norm.x;  
  g01 *= norm.y;  
  g10 *= norm.z;  
  g11 *= norm.w;  

  float n00 = dot(g00, vec2(fx.x, fy.x));
  float n10 = dot(g10, vec2(fx.y, fy.y));
  float n01 = dot(g01, vec2(fx.z, fy.z));
  float n11 = dot(g11, vec2(fx.w, fy.w));

  vec2 fade_xy = fade(Pf.xy);
  vec2 n_x = mix(vec2(n00, n01), vec2(n10, n11), fade_xy.x);
  float n_xy = mix(n_x.x, n_x.y, fade_xy.y);
  return 2.3 * n_xy;
}