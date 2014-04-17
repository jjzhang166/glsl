//
// A Brush, by @rianflo
//

#ifdef GL_ES
precision highp float;
#endif

#define EPSILON 0.0000001

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D bb;

vec3 mod289(vec3 x);
vec2 mod289(vec2 x);
vec3 permute(vec3 x);
float snoise(vec2 v);

float sdCircle(vec2 p, vec2 t, float r)
{
	return length(t-p) - r;
}

//float sdfRect(vec2 p, vec2 a, vec2 b, float k)
//{
//	return -softminf( softminf( softminf( -a.y+p.y, b.y-p.y, k ), -a.x+p.x, k ), b.x-p.x, k );
//}


float noiseFunc(vec2 p)
{
	p+=time*0.0001;
	return snoise(p * 4.0) * 0.5 + snoise(p * 8.0) * 0.25 + snoise(p * 16.0) * 0.125;
}

vec2 noiseField(vec2 p)
{
	return normalize(vec2(noiseFunc(p-vec2(0.0, EPSILON)), noiseFunc(p-vec2(EPSILON, 0.0))) - vec2(noiseFunc(p+vec2(0.0, EPSILON)), noiseFunc(p+vec2(EPSILON, 0.0))));
}

vec2 rotateVec(vec2 v, float angle)
{
	float vcos = cos(angle);
	float vsin = sin(angle);
	return vec2(v.x * vcos - v.y * vsin,
		    v.x * vsin + v.y * vcos);
}

void main() 
{
	float aspect = resolution.x / resolution.y;
	vec2 p = (-resolution.xy + 2.0 * gl_FragCoord.xy) / resolution.y;
	vec2 m = (mouse * 2.0 - 1.0) * vec2(aspect, 1.0);
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	
	vec4 old = texture2D(bb, uv);
		
	// ok we're going to do something non-GPU friendly next
	vec4 state = texture2D(bb, vec2(0.0)) * 4.0 - 2.0;
	if (length(state) > 3.4)
		state = vec4(0.0, 0.0, 1.0, 0.0);
		
	vec2 cursor = state.xy;
	//vec2 dir = state.zw + noiseField(cursor);
	float nf = noiseFunc(cursor);
	vec2 dir = rotateVec(state.zw, nf*0.5);
	
	cursor += dir * 1.0/60.0;
	cursor = clamp(cursor, vec2(-aspect, -1.0), vec2(aspect, 1.0));
	
	vec4 c = old; 
	if (sdCircle(p, cursor, clamp(nf*0.1, 0.02, 0.9)) < 0.0) {
		c = vec4(dir, nf+0.5, 1.0);
	} else {
	}
	
	
	
	if (length(gl_FragCoord.xy) <= 1.0) 
	{
		// save state
		state = vec4(cursor, dir);
		gl_FragColor = (state + 2.0) / 4.0;
	}
	else
	{
		gl_FragColor = vec4(c);
	}
}


// lib ---------------------------------------------------------------

//
// Description : Array and textureless GLSL 2D simplex noise function.
//      Author : Ian McEwan, Ashima Arts.
//  Maintainer : ijm
//     Lastmod : 20110822 (ijm)
//     License : Copyright (C) 2011 Ashima Arts. All rights reserved.
//               Distributed under the MIT License. See LICENSE file.
//               https://github.com/ashima/webgl-noise
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
  const vec4 C = vec4(0.211324865405187,  // (3.0-sqrt(3.0))/6.0
                      0.366025403784439,  // 0.5*(sqrt(3.0)-1.0)
                     -0.577350269189626,  // -1.0 + 2.0 * C.x
                      0.024390243902439); // 1.0 / 41.0
// First corner
  vec2 i  = floor(v + dot(v, C.yy) );
  vec2 x0 = v -   i + dot(i, C.xx);

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
  g.x  = a0.x  * x0.x  + h.x  * x0.y;
  g.yz = a0.yz * x12.xz + h.yz * x12.yw;
  return 130.0 * dot(m, g);
}
