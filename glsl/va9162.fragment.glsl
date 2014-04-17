#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define PI 3.14159265358979323846264
#define TWOPI 6.28318530717958647692528

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

float snoise(vec3 v) {
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

float mapCoordinate(float i1, float i2, float w1, float w2, float p) {
	return ((p - i1) / (i2 - i1)) * (w2 - w1) + w1;
}

vec3 sphericalToCartesian (float radius, float theta, float phi) {
	float x = radius * sin(phi) * cos(theta);
	float y = radius * sin(phi) * sin(theta);
	float z = radius * cos(phi);
	return vec3(x, y, z);
}

vec3 cartesianToSpherical (float x, float y, float z) {
	return vec3(1,1,1);
}

float clouds( vec3 coord ) {
	//float seed = 123.5;
	float n = snoise(coord);
	//v.xy *= 2.0;
	n += 0.5 * snoise(coord * 2.0);
	//v.xy *= 2.0;
	n += 0.25 * snoise(coord * 4.0);
	//v.xy *= 2.0;
	n += 0.125 * snoise(coord * 8.0);
	//v.xy *= 2.0;
	n += 0.0625 * snoise(coord * 16.0);
	//v.xy *= 2.0;
	n += 0.03125 * snoise(coord * 32.0);
	return n;
}

void main( void ) {

	float r = 0.5;
	
	vec2 screenPos = ( gl_FragCoord.xy / resolution.xy ) - 0.5;
	screenPos.x *= resolution.x / resolution.y;
	//if (length(screenPos) > r) discard;

	vec3 spherePos = vec3(screenPos.x, screenPos.y / 2.0, 0.0);
	float sphereRadius = 0.5;
	float zz = -(screenPos.x * screenPos.x + screenPos.y * screenPos.y - r * r);
	if (zz <= 0.0) discard;
	spherePos.z = sqrt(zz);
	
	float angle = mod(0.5 * time, TWOPI);
	float x1 = spherePos.x * cos(angle) - spherePos.z * sin(angle);
     	float z1 = spherePos.x * sin(angle) + spherePos.z * cos(angle);
	spherePos = vec3(x1, spherePos.y, z1);

	float theta = mapCoordinate(0.0, 1.0, TWOPI, 0.0, spherePos.x);
	float phi = mapCoordinate(0.0, 1.0, 0.0, PI, spherePos.y);
	
	vec3 coord = sphericalToCartesian(r, theta, phi);
	//coord = coord / 2.0 + 0.5;
	//coord.xz += mod(time * .1, 100.0) ;
	//coord.y += mouse.y * -5.;
	//if (coord.z > 0.1) discard;
	
	//float n = clouds(coord);
	float n = clouds(spherePos);
	
	vec3 lightPos = vec3(-1.0, 0.0, -1.0);
	float diffuse_value = max(dot(coord, lightPos), 0.0);
	
	

	//vec2 position = ( gl_FragCoord.xy / resolution.xy ) - 0.5;
	//position.x *= resolution.x / resolution.y;
	//float len = length(position);
		
	float terrain = smoothstep(0.05, 0.0, n); //block out some terrain
	//terrain *= smoothstep(0.1, 0.0, n2); //block out some terrain

	//float water = smoothstep(0.05, 0.0, n5); // extra water layer
	
	vec3 terrainColor = vec3(66./255., 97./255., 15.0/255.); //green
	
	//terrainColor = mix(vec3(101.0/255., 81.0/255., 19./255.), terrainColor, smoothstep(0.1, .9, 1.0-n)); // center landmass
	//terrainColor = mix(vec3(101.0/255., 81.0/255., 19./255.), terrainColor, smoothstep(0.1, .7, 1.0-n4)); // center landmass
	//terrainColor = mix(vec3(94.0/255., 67.0/255., 31./255.), terrainColor, smoothstep(0.0, 0.15, n)); //mix in dark edge
	//terrainColor += n*0.3;
	//terrainColor += n4*0.3;
	//terrainColor = mix(vec3(66./255., 97./255., 15.0/255.), terrainColor, smoothstep(0.1, .5, 1.0-n)); // mix in more green
	//terrainColor = mix(vec3(121.0/255., 81.0/255., 19./255.), terrainColor, smoothstep(0.1, .9, 1.0-n)); // mix in light colors
	//terrainColor = mix(vec3(94.0/255., 67.0/255., 31./255.), terrainColor, smoothstep(0.0, 0.15, n)); //mix in dark edge
	//terrainColor += n4*0.2;	

	vec3 color = vec3(11.0/255.0, 21.0/255.0, 71.0/255.); //water
	
	//color -= (1.0-n*3.0)*0.01;
	color = mix(terrainColor, color, terrain); //mix terrain with water
	//color = mix(vec3(11.0/255.0, 21.0/255.0, 71.0/255.), color, water); //mix in more water
	
	//color *= smoothstep(0.5, 0.495, len);
	//color *= smoothstep(0.65, .2, len);
	
	//vec3 glow = vec3(smoothstep(0.57, 0.3, len)) * vec3(0.6, 0.8, 1.5);
	
	color = clamp(color, 0.0, 1.0);
	//color.r = max(0.0, color.r);
	//color.g = max(0.0, color.g);
	//color.b = max(0.0, color.b);
	//color += glow * smoothstep(0.495, 0.5, len);
	
	gl_FragColor = vec4(color, 1.0);// * diffuse_value;

}