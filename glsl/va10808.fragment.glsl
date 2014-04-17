// Ray Marching (Sphere Tracing) experiment by Riccardo Gerosa aka h3r3 
// Blog: http://www.postronic.org/h3/ G+: https://plus.google.com/u/0/117369239966730363327 Twitter: http://twitter.com/#!/h3r3
// This GLSL shader is based on the awesome work of JC Hart and I Quilez. Features two lights with soft shadows, blobby objects, object space ambient occlusion.

precision highp float;

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
const float PI = 3.14159;
const int MAX_RAYMARCH_ITER = 30;
const float MIN_RAYMARCH_DELTA = 0.01;
const float GRADIENT_DELTA = 0.006;
const float SOFT_SHADOWS_FACTOR = 10.0;
   
uniform sampler2D backbuffer;

float timescale = .15;
vec2 uv = gl_FragCoord.xy/resolution.xy;
vec4 color = vec4(0.);

float hash(vec2 co)
{
	return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

//
// GLSL textureless classic 3D noise "cnoise",
// with an RSL-style periodic variant "pnoise".
// Author:  Stefan Gustavson (stefan.gustavson@liu.se)
// Version: 2011-10-11
//
// Many thanks to Ian McEwan of Ashima Arts for the
// ideas for permutation and gradient selection.
//
// Copyright (c) 2011 Stefan Gustavson. All rights reserved.
// Distributed under the MIT license. See LICENSE file.
// https://github.com/ashima/webgl-noise
//

vec3 mod289(vec3 x)
{
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

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

vec3 fade(vec3 t) {
  return t*t*t*(t*(t*6.0-15.0)+10.0);
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
	
float sdCube(vec3 v, vec3 size, vec3 position) {
	vec3 distance = abs(v + position) - size;
	vec3 distance_clamped = max(distance, 0.0);
	return length(distance_clamped) - 0.05;
}

float sdSphere(vec3 p, float s) {
    return length(p) - s;
}

float sdTorus(vec3 p, vec2 t) {
    vec2 q = vec2(length(p.xz) - t.x, p.y);
    return length(q) - t.y;
}

float sdPlane(vec3 p, vec4 n) { // n must be normalized
    return dot(p, n.xyz) + n.w;
}

float Blend(float d1, float d2) {
    float dd = cos((d1 - d2) * PI);
    return mix(d1, d2, dd);
}

float map(vec3 p, vec3 ray_dir) { //  ray_dir is used only for some optimizations
    	if (ray_dir.z <= 0.0 || p.z <= 1.0) { // Optimization: try not to compute blobby object distance when possible
        	
		vec3 np = vec3(p.x+time*timescale, p.y * 1.3, p.z * .6) * .25;
		float n = abs(cnoise(np*3.))*.25; //significantly slower than fract noise
			
		float terrain = sdPlane(vec3(0., -.25, 0.) + p + n * 2., vec4(normalize(vec3(0, 1., -.5)), 0.));		
		
		float path = sdCube(p, vec3(2., .1, .3), vec3(.4, -.1, -.2));	
		path = path-((1.-uv.y)+(fract(p.y*32.)-fract(p.x*16.+n)))*.01;
		path = mix(terrain + terrain-n*4., path, .85);
		
		vec4 sandColor = vec4(.9, .8, .6, 0.);
		vec4 pathColor = vec4(.32, .32, .42, 0.); 
		
		color = mix(sandColor, pathColor, .6); //durr, distance is warped - blend broken
		
		return min(terrain, path);
    	} else {
		vec4 skyColor = uv.y * .5 * vec4(.9 - (1.-uv.x), .6 * uv.y, .3 + (1.-uv.x), 1.) + .1;
        	color = skyColor;
		return 1.;
    	}
}

float map(vec3 p) {
    return map(p, vec3(0,0,0));
}

vec3 gradientNormal(vec3 p) {
    return normalize(vec3(
        map(p + vec3(GRADIENT_DELTA, 0, 0)) - map(p - vec3(GRADIENT_DELTA, 0, 0)),
        map(p + vec3(0, GRADIENT_DELTA, 0)) - map(p - vec3(0, GRADIENT_DELTA, 0)),
        map(p + vec3(0, 0, GRADIENT_DELTA)) - map(p - vec3(0, 0, GRADIENT_DELTA))));
}

bool raymarch(vec3 ray_start, vec3 ray_dir, out float dist, out vec3 p, out int iterations) {
    dist = 0.0;
    float minStep = 0.0001;
    for (int i = 1; i <= MAX_RAYMARCH_ITER; i++) {
        p = ray_start + ray_dir * dist;
        float mapDist = map(p, ray_dir);
        if (mapDist < MIN_RAYMARCH_DELTA) {
           iterations = i;
           return true;
        }
        if(mapDist < minStep) { mapDist = minStep; }
        dist += mapDist;
        float ifloat = float(i);
        minStep += 0.0000018 * ifloat * ifloat;
    }
    return false;
}

bool raymarch_to_light(vec3 ray_start, vec3 ray_dir, float maxDist, out float dist, out vec3 p, out int iterations, out float light_intensity) {
    dist = 2.;
    float minStep = 0.0001;
    light_intensity = 1.0;
    for (int i = 1; i <= MAX_RAYMARCH_ITER; i++) {
        p = ray_start + ray_dir * dist;
        float mapDist = map(p, ray_dir);
        if (mapDist < MIN_RAYMARCH_DELTA) {
            iterations = i;
            return true;
        }
        light_intensity = min(light_intensity, SOFT_SHADOWS_FACTOR * mapDist / dist);
        if(mapDist < minStep) { mapDist = minStep; }
        dist += mapDist;
        if (dist >= maxDist) { break; }
        float ifloat = float(i);
        minStep += 0.0000018 * ifloat * ifloat;
    }
    return false;
}

float ambientOcclusion(vec3 p, vec3 n) {
    float step = 0.03;
    float ao = 0.0;
    float dist;
    for (int i = 1; i <= 3; i++) {
        dist = step * float(i);
        ao += (dist - map(p + n * dist)) / float(i * i);
    }
    return ao;
}

vec4 render( void ) {
	color = vec4(0.);
    vec2 position = vec2((gl_FragCoord.x - resolution.x / 2.0) / resolution.y, (gl_FragCoord.y - resolution.y / 2.0) / resolution.y);
    vec3 ray_start = vec3(2, .10, -2.);
    vec3 ray_dir = normalize(vec3(position,0) - ray_start);

    float angleX = .0;//(mouse.y -0.5) * 0.5;
    float angleY = .25;//(mouse.x -0.5);
    float angleZ = .0;//(mouse.x -0.5) * 0.1;
    mat3 rotateX = mat3(1.0, 0.0, 0.0,
                        0.0, cos(angleX), -sin(angleX),
                        0.0, sin(angleX), cos(angleX));
    mat3 rotateY = mat3(cos(angleY), 0.0, sin(angleY),
                        0.0, 1.0, 0.0,
                        -sin(angleY), 0.0, cos(angleY));
    mat3 rotateZ = mat3(cos(angleZ), -sin(angleZ), 0.0,
                        sin(angleZ), cos(angleZ), 0.0,
                        0.0, 0.0, 1.0);
    ray_dir = ray_dir * rotateX * rotateY * rotateZ;
   	
	ray_start.x = .5;//-mouse.x * 3.0 + 1.5;
   	ray_start.y = .5;//mouse.y * 1.0 - 0.5;
	ray_start.y = .5;

	
    vec3 light1_pos = vec3(-0.5 + sin(time), 1.0, -1.0 + cos(time * 0.5) * 2.0);
    vec3 light2_pos = vec3(sin(time * 1.9 + 2.0) * 0.6, sin(time * 1.8) + 5.0, -0.5 + sin(time * 1.6) * 0.5);
  
	float dist; vec3 p; int iterations;
    if (raymarch(ray_start, ray_dir, dist, p, iterations)) {
        float d2; vec3 p2; int i2; float light_intensity;

        vec3 light1_dir = light1_pos - p;
        float light1_dist = length(light1_dir);
        light1_dir = normalize(light1_dir);

        vec3 light2_dir = light2_pos - p;
        float light2_dist = length(light2_dir);
        light2_dir = normalize(light2_dir);

        vec3 n = gradientNormal(p);
        float ambient = (0.16 - ambientOcclusion(p, n)) / (dist * dist * 0.17);
        vec3 diffuse1 = vec3(0,4,0);
        if (!raymarch_to_light(p + light1_dir * 0.1, light1_dir, light1_dist, d2, p2, i2, light_intensity)) {
            diffuse1 = vec3(1.0, 0.8, 0.6) * max(0.0, dot(normalize(light1_pos - p), n) * light_intensity * 3.0 / (dist * dist));
        }
        vec3 diffuse2 = vec3(0,0,0);
        if (!raymarch_to_light(p + light2_dir * 0.1, light2_dir, light2_dist, d2, p2, i2, light_intensity)) {
            diffuse2 = vec3(0.6, 0.8, 1.0) * max(0.0, dot(normalize(light2_pos - p), n) * light_intensity * 3.0 / (dist * dist));
        }
        color.rgb = color.rgb * max(diffuse1 + diffuse2, ambient);
    }
    return color;
}


void main(){
	float pixel = mouse.y/resolution.y;
	timescale = .25; //tune time scale - output picture is fps dependent and gets stretched or contracted based on speed
	
	gl_FragColor = render();
	
	
	if(gl_FragCoord.x > resolution.x - 1.){
		gl_FragColor = render(); //fully rendered
	}
	else{
		vec4 buffer = gl_FragColor = texture2D(backbuffer, uv + vec2(pixel, 0.)); //buffered from 1 pixel to the right
	}
	
}//sphinx
