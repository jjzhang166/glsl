#ifdef GL_ES
precision mediump float;
#endif

//
//
// Description : Array and textureless GLSL 2D/3D/4D simplex
// noise functions.
// Author : Ian McEwan, Ashima Arts.
// Maintainer : ijm
// Lastmod : 20110822 (ijm)
// License : Copyright (C) 2011 Ashima Arts. All rights reserved.
// Distributed under the MIT License. See LICENSE file.
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

vec4 taylorInvSqrt(vec4 r)
{
  return 1.79284291400159 - 0.85373472095314 * r;
}

float snoise(vec3 v)
  {
  const vec2 C = vec2(1.0/6.0, 1.0/3.0) ;
  const vec4 D = vec4(0.0, 0.5, 1.0, 2.0);

// First corner
  vec3 i = floor(v + dot(v, C.yyy) );
  vec3 x0 = v - i + dot(i, C.xxx) ;

// Other corners
  vec3 g = step(x0.yzx, x0.xyz);
  vec3 l = 1.0 - g;
  vec3 i1 = min( g.xyz, l.zxy );
  vec3 i2 = max( g.xyz, l.zxy );

  // x0 = x0 - 0.0 + 0.0 * C.xxx;
  // x1 = x0 - i1 + 1.0 * C.xxx;
  // x2 = x0 - i2 + 2.0 * C.xxx;
  // x3 = x0 - 1.0 + 3.0 * C.xxx;
  vec3 x1 = x0 - i1 + C.xxx;
  vec3 x2 = x0 - i2 + C.yyy; // 2.0*C.x = 1/3 = C.y
  vec3 x3 = x0 - D.yyy; // -1.0+3.0*C.x = -0.5 = -D.y

// Permutations
  i = mod289(i);
  vec4 p = permute( permute( permute(
             i.z + vec4(0.0, i1.z, i2.z, 1.0 ))
           + i.y + vec4(0.0, i1.y, i2.y, 1.0 ))
           + i.x + vec4(0.0, i1.x, i2.x, 1.0 ));

// Gradients: 7x7 points over a square, mapped onto an octahedron.
// The ring size 17*17 = 289 is close to a multiple of 49 (49*6 = 294)
  float n_ = 0.142857142857; // 1.0/7.0
  vec3 ns = n_ * D.wyz - D.xzx;

  vec4 j = p - 49.0 * floor(p * ns.z * ns.z); // mod(p,7*7)

  vec4 x_ = floor(j * ns.z);
  vec4 y_ = floor(j - 7.0 * x_ ); // mod(j,N)

  vec4 x = x_ *ns.x + ns.yyyy;
  vec4 y = y_ *ns.x + ns.yyyy;
  vec4 h = 1.0 - abs(x) - abs(y);

  vec4 b0 = vec4( x.xy, y.xy );
  vec4 b1 = vec4( x.zw, y.zw );

  //vec4 s0 = vec4(lessThan(b0,0.0))*2.0 - 1.0;
  //vec4 s1 = vec4(lessThan(b1,0.0))*2.0 - 1.0;
  vec4 s0 = floor(b0)*2.0 + 1.0;
  vec4 s1 = floor(b1)*2.0 + 1.0;
  vec4 sh = -step(h, vec4(0.0));

  vec4 a0 = b0.xzyw + s0.xzyw*sh.xxyy ;
  vec4 a1 = b1.xzyw + s1.xzyw*sh.zzww ;

  vec3 p0 = vec3(a0.xy,h.x);
  vec3 p1 = vec3(a0.zw,h.y);
  vec3 p2 = vec3(a1.xy,h.z);
  vec3 p3 = vec3(a1.zw,h.w);

//Normalise gradients
  vec4 norm = taylorInvSqrt(vec4(dot(p0,p0), dot(p1,p1), dot(p2, p2), dot(p3,p3)));
  p0 *= norm.x;
  p1 *= norm.y;
  p2 *= norm.z;
  p3 *= norm.w;

// Mix final noise value
  vec4 m = max(0.6 - vec4(dot(x0,x0), dot(x1,x1), dot(x2,x2), dot(x3,x3)), 0.0);
  m = m * m;
  return 42.0 * dot( m*m, vec4( dot(p0,x0), dot(p1,x1),
                                dot(p2,x2), dot(p3,x3) ) );
  }
//

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

const float EPSILON = 0.00001;

struct Camera
{
	vec3 position;
	vec3 dir;
	vec3 up;
	vec3 rayDir;
	vec2 screenPosition;
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

float smoothcurve(float f) {
	return 0.5*(1.0+cos(3.14*f));
}


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

MapResult map_cube(vec3 position)
{
	MapResult result;
	result.color = vec3(1.0, 0.5, 0.2);
	
	float cube = length(max(abs(position) - vec3(1.2), 0.0)) - 0.1;
	float sphere = length(position) - 1.6;
	
	float d = max(cube, -sphere);
		
	result.dist = d;
	return result;
}

MapResult map_torus(vec3 position)
{
	MapResult result;
	result.color = vec3(0.0, 0.5, 0.8);
	
	position = (rotationMatrix(vec3(0,0,1), time) * vec4(position, 1.0)).xyz;
	position = (rotationMatrix(vec3(0,1,0), time) * vec4(position, 1.0)).xyz;
	position = (rotationMatrix(vec3(1,0,0), time) * vec4(position, 1.0)).xyz;
	
	vec2 q = vec2(length(position.xz) - 2.5, position.y);
	result.dist = length(q) - 0.2;
	
	result.dist = result.dist + snoise(position + mod(time * 0.5, 23.0) ) * 0.1;
		
	return result;
}

MapResult map_floor(vec3 position)
{
	MapResult result;
	result.dist = dot(position, vec3(0.0, 1.0, 0.0)) + 2.5;
	result.color = vec3(0.4);
	
	return result;
}

MapResult combine(MapResult a, MapResult b)
{
	if(a.dist < b.dist)
	{
		return a;	
	}
	return b;
}

MapResult map(vec3 position)
{
	MapResult result;
	float c = 10.0;
	//position = mod(position, vec3(c)) - c*0.5;
	
	result = map_floor(position);
	
	result = combine(result, map_cube(position));
	result = combine(result, map_torus(position));
		
	return result;
}

vec3 getColor(const in Camera cam, const in vec3 position, const in float dist, const in vec3 color)
{	
	vec3 eps = vec3(EPSILON, 0, 0);
	
	
	vec3 normal=normalize(
		   vec3(dist - map(position-eps.xyy).dist,
			dist - map(position-eps.yxy).dist,
			dist - map(position-eps.yyx).dist));
	
	
	float lambert = dot(normal, -cam.rayDir);
	
	vec3 outcolor = lambert * color;	
	return outcolor;
}

MarchResult raymarch(const in Camera cam)
{
	MarchResult result;
	result.color = vec3(0.05);
	
	const int MAX_ITERATIONS = 256;
	const float MAX_DEPTH = 128.0;
	
	float depth = 0.0;
	MapResult mapping;
	float beam = 0.0;
	for(int i = 0; i < MAX_ITERATIONS; ++i)
	{
		result.position = cam.position + cam.rayDir * depth;
		mapping = map(result.position);
		
		if(mapping.dist <= EPSILON)
		{
			break;
		}
		
		depth += mapping.dist * 0.7;
		
		
		/*float beam1_length = 0.5;
		float beam1_width = 0.5;
		float beam2_length = 1.5;
		float beam2_width = 0.5;
		
		vec3 foo = result.position;
   		float angle=atan(foo.x,foo.y);
		float cell=floor((angle/3.143+1./16.)/(1./8.));
		float len=mod(cell,2.0)*beam1_length+mod(cell+1.0,2.0)*beam2_length;
		float rad=mod(cell,2.0)*beam1_width+mod(cell+1.0,2.0)*beam2_width;
		//float beam=(-rad+length(foo.xy)+0.05*1.0*(foo.zzz*1.5+t*10.0))+max(foo.z-2.0,0.0)+0.5*min(max(-foo.z+3.0-len,0.0),0.8);
		float foobeam = (-rad + length(foo.xy))+ max(foo.z-2.0,0.0)+0.5*min(max(-foo.z+3.0-len,0.0),0.8);
		beam += max(-foobeam, 0.0) * 10.0;*/
				
		if(depth >= MAX_DEPTH)
		{
			break;
		}
	}
	
	result.dist = mapping.dist;
	
	if(depth < MAX_DEPTH)
		result.color = getColor(cam, result.position, result.dist, mapping.color);
			
	//result.color = mix(result.color, vec3(0.2, 0.4, 0.9), max(beam, 0.0));
	
	return result;
}
	
Camera getCamera()
{
	Camera cam;
  	cam.dir = vec3(0,0,0);
	float t = (time+3.0) * 0.15;
	cam.position = vec3(sin(t + 1.0)*4.0, 5, cos(t)*4.0);
	cam.up = vec3(0,1,0);
  	vec3 forward = normalize(cam.dir - cam.position);
  	vec3 left = cross(forward, cam.up);
 	cam.up = cross(left, forward);
 
	vec3 screenOrigin = (cam.position+forward);
	cam.screenPosition = 2.0*gl_FragCoord.xy/resolution.xy - 1.0;
 	float screenAspectRatio = resolution.x/resolution.y;
	vec3 screenHit = screenOrigin + cam.screenPosition.x * left * screenAspectRatio + cam.screenPosition.y * cam.up;
  
	cam.rayDir = normalize(screenHit-cam.position);
	return cam;
}

void main() 
{	
	Camera cam = getCamera();
	MarchResult result = raymarch(cam);
	
	vec3 color = result.color;

	gl_FragColor = vec4(color, 1.0);
}