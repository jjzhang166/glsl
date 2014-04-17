// by @eddbiddulph

#ifdef GL_ES
precision highp float;
#endif

#define EPS vec2(0.0001, 0.0)

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//
// Description : Array and textureless GLSL 2D simplex noise function.
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

vec2 mod289(vec2 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec3 permute(vec3 x) {
  return mod289(((x*34.0)+1.0)*x);
}

float snoise(vec2 v)
  {
  const vec4 C = vec4(0.211324865405187, // (3.0-sqrt(3.0))/6.0
                      0.366025403784439, // 0.5*(sqrt(3.0)-1.0)
                     -0.577350269189626, // -1.0 + 2.0 * C.x
                      0.024390243902439); // 1.0 / 41.0
// First corner
  vec2 i = floor(v + dot(v, C.yy) );
  vec2 x0 = v - i + dot(i, C.xx);

// Other corners
  vec2 i1;
  //i1.x = step( x0.y, x0.x ); // x0.x > x0.y ? 1.0 : 0.0
  //i1.y = 1.0 - i1.x;
  i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
  // x0 = x0 - 0.0 + 0.0 * C.xx ;
  // x1 = x0 - i1 + 1.0 * C.xx ;
  // x2 = x0 - 1.0 + 2.0 * C.xx ;
  vec4 x12 = x0.xyxy + C.xxzz;
  x12.xy -= i1;

// Permutations
  i = mod289(i); // Avoid truncation effects in permutation
  vec3 p = permute( permute( i.y + vec3(0.0, i1.y, 1.0 ))
+ i.x + vec3(0.0, i1.x, 1.0 ));

  vec3 m = max(0.5 - vec3(dot(x0,x0), dot(x12.xy,x12.xy), dot(x12.zw,x12.zw)), 0.0);
  m = m*m ;
  m = m*m ;

// Gradients: 41 points uniformly over a line, mapped onto a diamond.
// The ring size 17*17 = 289 is close to a multiple of 41 (41*7 = 287)

  vec3 x = 2.0 * fract(p * C.www) - 1.0;
  vec3 h = abs(x) - 0.5;
  vec3 ox = floor(x + 0.5);
  vec3 a0 = x - ox;

// Normalise gradients implicitly by scaling m
// Approximation of: m *= inversesqrt( a0*a0 + h*h );
  m *= 1.79284291400159 - 0.85373472095314 * ( a0*a0 + h*h );

// Compute final noise value at P
  vec3 g;
  g.x = a0.x * x0.x + h.x * x0.y;
  g.yz = a0.yz * x12.xz + h.yz * x12.yw;
  return 130.0 * dot(m, g);
}

float fbm(vec2 p)
{
	float x = 0.0;
  
  for(int i = 0; i < 4; ++i) {
    		x += snoise(p * pow(2.0, float(i))) / pow(2.0, float(i));
  }
  
    	return x;
}

float htex(vec2 p)
{
	return fbm(p * 2.0) * 0.002;
}

vec3 ntex(vec2 p)
{
	float h = htex(p);

	vec3 s = vec3(EPS.x, htex(p + EPS.xy) - h, 0.0);
	vec3 t = vec3(0.0, htex(p + EPS.yx) - h, EPS.x);

	return normalize(cross(t, s));
}

float plane(vec3 ro, vec3 rd, vec3 pln_norm, float pln_dist)
{
	return (pln_dist - dot(pln_norm, ro)) / dot(pln_norm, rd);
}

float box(float e0, float e1, float x)
{
	return step(e0, x) - step(e1, x);
}

float boardMask(vec2 p)
{
    p.x = mod(p.x - time, 10.0) - 2.0 + sin(p.y * 4.0 + time + p.x) * 0.1;

    return max(0.0, (1.0 - abs(0.45 - length(p - 0.5)) * 10.0) *
            (1.2 + (0.8 + cos(p.y * 20.0 + time * 30.0) * 0.2) * pow(cos(p.y * 100.0 - time * 20.0), 2.0)) * 0.5) * 1.2;
}

vec3 singleBoard(vec3 ro, vec3 rd, vec2 offset, float dist)
{
	float t = plane(ro, rd, vec3(0.0, 0.0, 1.0), dist);

  	if(t < 0.0)
		return vec3(0.0);

	return vec3(boardMask(ro.xy + rd.xy * t + vec2(offset.x, 1.0 - abs(cos(time + offset.y)))));
}

vec3 boards(vec3 ro, vec3 rd)
{
	return 	singleBoard(ro, rd, vec2(0.0, 2.0), 4.0) * vec3(1.0, 0.8, 0.7) +
		singleBoard(ro, rd, vec2(2.0, 0.0), 6.0) * vec3(0.7, 0.8, 1.0) + 
		singleBoard(ro, rd, vec2(-3.0, 0.5), 5.0) * vec3(1.0, 1.0, 0.7) + 
		singleBoard(ro, rd, vec2(-2.0, 1.0), 2.0) * vec3(0.7, 1.0, 0.8);
}

vec3 ground(vec3 ro, vec3 rd)
{
	float t = plane(ro, rd, vec3(0.0, -1.0, 0.0), 1.0);

	if(t < 0.0)
		return vec3(0.0);

	vec3 p = ro + rd * t;

	return boards(p, reflect(rd, ntex(p.xz))) * 0.9;
}

vec3 rotateZ(vec3 v, float a)
{
    return vec3(v.x * cos(a) - v.y * sin(a), v.x * sin(a) + v.y * cos(a), v.z);
}

vec3 rotateY(vec3 v, float a)
{
    return vec3(v.x * cos(a) - v.z * sin(a), v.y, v.x * sin(a) + v.z * cos(a));
}

void main( void ) {

	vec3 rd = vec3(0.0, 0.0, 1.0), ro = vec3(0.0);

	rd.xy = (gl_FragCoord.xy / resolution.xy - 0.5) * 2.0 * vec2(resolution.x / resolution.y, 1.0);

    rd = rotateZ(rd, cos(time * 0.2) * 0.06);
    rd = rotateY(rd, cos(time * 0.6) * 0.17);
    gl_FragColor.a = 1.0;
	gl_FragColor.rgb = ground(ro, rd) + boards(ro, rd);
}