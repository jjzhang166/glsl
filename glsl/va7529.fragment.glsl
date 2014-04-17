/*
 * Ray tracing
 * @author Santiago Sanchez (santi.sanchez28@gmail.com)
 * Perlin noise implementation by Stefan Gustavson.
 * 03-02-2013
 */

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float EPSILON = 0.001;
const float PI = 3.14159265359;

const float FAR = 1000.0;
const float NEAR = 0.1;

const vec3 Ambient = vec3(0.1, 0.1, 0.15);
const vec3 SkyColor = vec3(0.06, 0.28, 0.73);
const vec3 HorizonColor = vec3(0.23, 0.14, 0.34);
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
float cnoise(vec3 P);

struct Material
{
	vec3 diffuse;
	float shininess;
	float glossiness;
};

struct Sphere
{
	vec3 center;
	float radius;
	Material mat;
};
	
struct Plane
{
	vec3 normal;
	vec3 point;
	Material mat;
};

struct Ray
{
	vec3 origin;
	vec3 dir;
};

// Global variables
Sphere g_sphere = Sphere(vec3(0.0, 2.0, 5.0), 1.5, Material(vec3(0.8, 0.2, 0.1), 16.0, 0.0));
Plane g_plane = Plane(vec3(0.0, 1.0, 0.0), vec3(0.0, -1.0, 0.0), Material(vec3(0.1, 0.8, 0.1), 32.0, 0.5));
vec3 g_rayOrigin = vec3(4.0 * (mouse.x - 0.5), 2.0 * mouse.y, 0.5);

float theta = PI/3.0;
float phi = /*PI/4.0;*/ (sin(0.2 * time) * 0.5 + 0.5) * PI * 0.6;
vec3 g_sunPos = g_rayOrigin + FAR * vec3(cos(theta)*sin(phi), sin(theta)*sin(phi), cos(phi));

	
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
}

vec2 sphereTexCoords(vec3 vp)
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

float sinSumAbsNoise(float x, vec2 p) {
	return sin(x + sumAbsNoise(p));
}

float sumNoise(vec3 p)
{
	float f = 0.0;
	for (float i=0.0; i < 8.0; i++) 
	{
		float w = pow(2.0, i);
		f +=  cnoise(p * w) / w;
	}	
	return f;
}

float sumAbsNoise(vec3 p)
{
	float f = 0.0;
	for (float i=0.0; i < 8.0; i++) 
	{
		float w = pow(2.0, i);
		f +=  abs(cnoise(p * w)) / w;
	}
	return f;
}

float sinSumAbsNoise(float x, vec3 p) {
	return sin(x + sumAbsNoise(p));
}

vec3 getSkyColor(vec3 origin, vec3 skyPoint, vec3 sunPos)
{
	vec3 skyDir = normalize(skyPoint - origin);
	vec3 sunDir = normalize(sunPos - origin);
	float sunDot = dot(skyDir, sunDir);
		
	vec3 rays = vec3(0.7 * pow(max(0.0, sunDot), 50.0));	
	vec3 sun = vec3(0.4 * pow(max(0.001, sunDot), 500.0));
	
	float curve = 1.0 - pow(1.0 - max(skyDir.y, 0.1), 10.0); //sqrt(skyDir.y);
	vec3 sky = mix(HorizonColor, SkyColor, curve);	
	
	vec2 uv = sphereTexCoords(skyPoint);
	//clouds with 2D noise:
	//vec3 clouds = 0.4 * vec3(sumNoise(8.0 * uv + vec2(0.05 * time, 0.0))) * smoothstep(0.0, 0.4, uv.y);	
	//clouds with 3D noise:
	vec3 clouds = 1.4*vec3(sumNoise(0.002*skyPoint + vec3(0.02, 0.0, 0.03)*time))*smoothstep(0.0, 0.5, uv.y);

	float alpha = 1.0 - clouds.x;
	return alpha * (sky + sun + rays) + clouds;
}

vec3 shade(Material mat, vec3 normal, vec3 lightDir, vec3 viewDir, vec3 reflectDir, 
	   vec3 reflectedColor, float shadow)
{
	const vec3 specularColor = vec3(0.8);
	float NdotL = max(dot(normal, lightDir), 0.0);
	float RdotV = max(dot(viewDir, reflectDir), 0.0);
	vec3 spec = pow(RdotV, mat.shininess) * specularColor;
	return mat.diffuse * (NdotL * shadow + Ambient) + shadow * mat.glossiness * (spec + RdotV * reflectedColor);
}

float intersectWithScene(Ray ray, out float dist)
{
	dist = FAR;
	float ts = intersectSphere(g_sphere, ray);
	float tp = intersectPlane(g_plane, ray);
	
	if (ts > 0.0) {
		dist = ts;
		return 0.5;
	}
	if (tp > 0.0 && tp < dist) {
		dist = tp;
		return 1.5;
	}
	return -1.0;
}

// This is the same as getColor but for reflection rays.
// The difference is that it doesn't cast reflection rays
vec3 getColorSimple(float objectId, Ray ray, float dist)
{
	vec3 color = vec3(0.0);
	if (objectId < 0.0) //sky 
	{		
		vec3 skyPoint = ray.origin + SkyDistance * ray.dir;		
		color = getSkyColor(ray.origin, skyPoint, g_sunPos);
	}
	else if (objectId < 1.0) //sphere
	{
		vec3 point = ray.origin + dist * ray.dir;
		vec3 vp = point - g_sphere.center;
		vec3 normal = normalize(vp);
		
		vec3 lightDir = normalize(g_sunPos - point);
		float shadow = max(dot(normal, lightDir), 0.2);
		
		vec2 uv = projectiveTexCoords(vp); //sphereTexCoords(g_sphere, vp);
		float texColor = 1.1*(sumAbsNoise(vp + vec3(0.1, 0.1, 0.5)*time)*0.5 + 0.5) + 
			0.4*(sinSumAbsNoise(point.y*point.x, 20.0*uv + vec2(0.1, 0.5)*time)*0.5 + 0.5);
		
		vec3 reflectedColor = vec3(0.0);
		vec3 reflectDir = reflect(ray.dir, g_plane.normal);	
		
		g_sphere.mat.diffuse *= texColor;
		color = shade(g_sphere.mat, normal, lightDir, ray.dir, reflectDir, 
			reflectedColor, shadow);
	}
	else //plane
	{
		vec3 point = ray.origin + dist * ray.dir;
		vec3 vecToLight = g_sunPos - point;
		float distToLight = length(vecToLight);
		vec3 lightDir = normalize(vecToLight);
		
		//shadow
		Ray rayToLight = Ray(point + lightDir * EPSILON, lightDir);
		float ts = intersectSphere(g_sphere, rayToLight);
		float shadow = 1.0;
		if (ts > 0.0) {
			shadow = 1.0 - ts / (0.5 + 0.5*ts + 0.5*ts*ts);
		}
		vec3 vecToSphere = g_sphere.center - point;
		float distToSphere = length(vecToSphere);
		shadow *= smoothstep(0.0, 4.5, distToSphere);		
		
		vec3 reflectedColor = vec3(0.0);
		vec3 reflectDir = reflect(ray.dir, g_plane.normal);			
		
		color = shade(g_plane.mat, g_plane.normal, lightDir, ray.dir, reflectDir, 
			reflectedColor, shadow);
	}
	return color;
}

vec3 getColor(float objectId, Ray ray, float dist)
{
	vec3 color = vec3(0.0);
	if (objectId < 0.0) //sky 
	{		
		vec3 skyPoint = ray.origin + SkyDistance * ray.dir;		
		color = getSkyColor(ray.origin, skyPoint, g_sunPos);
	}
	else if (objectId < 1.0) //sphere
	{
		vec3 point = ray.origin + dist * ray.dir;
		vec3 vp = point - g_sphere.center;
		vec3 normal = normalize(vp);
		
		vec3 lightDir = normalize(g_sunPos - point);
		float shadow = max(dot(normal, lightDir), 0.2);
		
		vec2 uv = projectiveTexCoords(vp); //sphereTexCoords(g_sphere, vp);
		float texColor = 1.1*(sumAbsNoise(vp + vec3(0.1, 0.1, 0.5)*time)*0.5 + 0.5) + 
			0.4*(sinSumAbsNoise(point.y*point.x, 20.0*uv + vec2(0.1, 0.5)*time)*0.5 + 0.5);
		
		vec3 reflectedColor = vec3(0.0);
		vec3 reflectDir = reflect(ray.dir, g_plane.normal);
		
		//Ray reflectedRay = Ray(point + reflectDir * EPSILON, reflectDir);
		//float reflectedObjectId = intersectWithScene(reflectedRay, dist);
		//reflectedColor = getColorSimple(reflectedObjectId, reflectedRay, dist);		
		
		g_sphere.mat.diffuse *= texColor;
		color = shade(g_sphere.mat, normal, lightDir, ray.dir, reflectDir, 
			reflectedColor, shadow);
	}
	else //plane
	{
		vec3 point = ray.origin + dist * ray.dir;
		vec3 vecToLight = g_sunPos - point;
		float distToLight = length(vecToLight);
		vec3 lightDir = normalize(vecToLight);
		
		//shadow
		Ray rayToLight = Ray(point + lightDir * EPSILON, lightDir);
		float ts = intersectSphere(g_sphere, rayToLight);
		float shadow = 1.0;
		if (ts > 0.0) {
			shadow = 1.0 - ts / (0.5 + 0.5*ts + 0.5*ts*ts);
		}
		vec3 vecToSphere = g_sphere.center - point;
		float distToSphere = length(vecToSphere);
		shadow *= smoothstep(0.0, 4.5, distToSphere);	
		
		vec3 reflectedColor = vec3(0.0);
		vec3 reflectDir = reflect(ray.dir, g_plane.normal);		
		
		Ray reflectedRay = Ray(point + reflectDir * EPSILON, reflectDir);
		float reflectedObjectId = intersectWithScene(reflectedRay, dist);
		reflectedColor = getColorSimple(reflectedObjectId, reflectedRay, dist);
		
		color = shade(g_plane.mat, g_plane.normal, lightDir, ray.dir, reflectDir, 
			reflectedColor, shadow);
	}
	return color;
}

void main() 
{	
	vec2 screenUv = gl_FragCoord.xy / resolution.xy;
	Ray ray = Ray(g_rayOrigin, normalize(vec3((2.0 * screenUv - 1.0) * AspectRatio, 1.0)));	
		
	float dist;
	float objectId = intersectWithScene(ray, dist);	
	vec3 color = getColor(objectId, ray, dist);
	
	//tone-mapping
	//const float exposure = 1.6;
	//color *= exposure;
	//color /= color + 1.0;

	gl_FragColor = vec4( color, 1.0 );
}
///////////////////////////////////////////////////////////////////////////////


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

vec3 mod289(vec3 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec4 mod289(vec4 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec4 permute(vec4 x) {
  return mod289(((x*34.0)+1.0)*x);
}

vec4 taylorInvSqrt(vec4 r) {
  return 1.79284291400159 - 0.85373472095314 * r;
}

vec2 fade(vec2 t) {
  return t*t*t*(t*(t*6.0-15.0)+10.0);
}

vec3 fade(vec3 t) {
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

// Classic Perlin noise
float cnoise(vec3 P)
{
  vec3 Pi0 = floor(P); // Integer part for indexing
  vec3 Pi1 = Pi0 + vec3(1.0); // Integer part + 1
  Pi0 = mod289(Pi0);
  Pi1 = mod289(Pi1);
  vec3 Pf0 = fract(P); // Fractional part for interpolation
  vec3 Pf1 = Pf0 - vec3(1.0); // Fractional part - 1.0
  vec4 ix = vec4(Pi0.x, Pi1.x, Pi0.x, Pi1.x);
  vec4 iy = vec4(Pi0.yy, Pi1.yy);
  vec4 iz0 = Pi0.zzzz;
  vec4 iz1 = Pi1.zzzz;

  vec4 ixy = permute(permute(ix) + iy);
  vec4 ixy0 = permute(ixy + iz0);
  vec4 ixy1 = permute(ixy + iz1);

  vec4 gx0 = ixy0 * (1.0 / 7.0);
  vec4 gy0 = fract(floor(gx0) * (1.0 / 7.0)) - 0.5;
  gx0 = fract(gx0);
  vec4 gz0 = vec4(0.5) - abs(gx0) - abs(gy0);
  vec4 sz0 = step(gz0, vec4(0.0));
  gx0 -= sz0 * (step(0.0, gx0) - 0.5);
  gy0 -= sz0 * (step(0.0, gy0) - 0.5);

  vec4 gx1 = ixy1 * (1.0 / 7.0);
  vec4 gy1 = fract(floor(gx1) * (1.0 / 7.0)) - 0.5;
  gx1 = fract(gx1);
  vec4 gz1 = vec4(0.5) - abs(gx1) - abs(gy1);
  vec4 sz1 = step(gz1, vec4(0.0));
  gx1 -= sz1 * (step(0.0, gx1) - 0.5);
  gy1 -= sz1 * (step(0.0, gy1) - 0.5);

  vec3 g000 = vec3(gx0.x,gy0.x,gz0.x);
  vec3 g100 = vec3(gx0.y,gy0.y,gz0.y);
  vec3 g010 = vec3(gx0.z,gy0.z,gz0.z);
  vec3 g110 = vec3(gx0.w,gy0.w,gz0.w);
  vec3 g001 = vec3(gx1.x,gy1.x,gz1.x);
  vec3 g101 = vec3(gx1.y,gy1.y,gz1.y);
  vec3 g011 = vec3(gx1.z,gy1.z,gz1.z);
  vec3 g111 = vec3(gx1.w,gy1.w,gz1.w);

  vec4 norm0 = taylorInvSqrt(vec4(dot(g000, g000), dot(g010, g010), dot(g100, g100), dot(g110, g110)));
  g000 *= norm0.x;
  g010 *= norm0.y;
  g100 *= norm0.z;
  g110 *= norm0.w;
  vec4 norm1 = taylorInvSqrt(vec4(dot(g001, g001), dot(g011, g011), dot(g101, g101), dot(g111, g111)));
  g001 *= norm1.x;
  g011 *= norm1.y;
  g101 *= norm1.z;
  g111 *= norm1.w;

  float n000 = dot(g000, Pf0);
  float n100 = dot(g100, vec3(Pf1.x, Pf0.yz));
  float n010 = dot(g010, vec3(Pf0.x, Pf1.y, Pf0.z));
  float n110 = dot(g110, vec3(Pf1.xy, Pf0.z));
  float n001 = dot(g001, vec3(Pf0.xy, Pf1.z));
  float n101 = dot(g101, vec3(Pf1.x, Pf0.y, Pf1.z));
  float n011 = dot(g011, vec3(Pf0.x, Pf1.yz));
  float n111 = dot(g111, Pf1);

  vec3 fade_xyz = fade(Pf0);
  vec4 n_z = mix(vec4(n000, n100, n010, n110), vec4(n001, n101, n011, n111), fade_xyz.z);
  vec2 n_yz = mix(n_z.xy, n_z.zw, fade_xyz.y);
  float n_xyz = mix(n_yz.x, n_yz.y, fade_xyz.x); 
  return 2.2 * n_xyz;
}