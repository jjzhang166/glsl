// by @eddbiddulph

#ifdef GL_ES
precision highp float;
#endif

#define EPS vec3(0.0001, 0.0, 0.0)

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

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

float circle(vec2 o, float r, vec2 p)
{
	return distance(p, o) - r;
}

float box(vec2 o, vec2 s, vec2 p)
{
	return length(max(vec2(0.0), abs(p - o) - s));
}

float wineGlassProfile(vec2 p)
{
	p.y = -p.y - 0.7;

	vec2 a = vec2(0.45, 0.67), b = vec2(0.0, 0.2);
	float g = 0.4, h = (a.x - b.x) - g;
	vec2 c = vec2(h, -0.9), d = vec2(0.2, -1.15), c2 = vec2(0.0, c.y);
	float i = (d.x - c2.x) - h, j = 0.72, k = (c2.y - d.y) - i;
	float l = 0.6, m = 0.8, f = a.y - b.y - g;

	float dist;
	
	// base
	dist = box(vec2(b.x, a.y - f * 0.5), vec2(m, f * 0.5 - 0.05), p) - 0.05;

	// bottom of stem
	dist = min(dist, max(box((a + b) * 0.5, abs(a - b) * 0.5, p), -circle( vec2(a.x, b.y), g, p)));

	// stem
	dist = min(dist, box((c + b) * 0.5, abs(b - c) * 0.5, p));

	// top of stem
	dist = min(dist, max(box((c2 + d) * 0.5, abs(d - c2) * 0.5, p), -circle( vec2(d.x, c2.y), i, p))   );

	// base of body
	dist = min(dist, max(max(max(circle(vec2(d.x, (d.y - j) + k), j, p), -circle(vec2(d.x, (d.y - j) + k), j - k, p)), d.x - p.x), d.y - j + k - p.y));

	// body
	dist = min(dist, -0.05 + box(vec2(d.x + j - k * 0.5, (d.y - j) + k - l * 0.5 ), vec2(k * 0.5 - 0.05, l * 0.5), p));

	return dist;
}

// signed distance function for wine-glass model. revolution of profile
// is around z-axis. the base of the glass is at a higher z than the rim.
float wineGlass(vec3 p)
{
	return wineGlassProfile(vec2(length(p.xy), p.z));
}

vec3 rotateY(vec3 v, float a)
{
	return vec3(cos(a) * v.x - sin(a) * v.z, v.y, sin(a) * v.x + cos(a) * v.z);
}

vec3 rotateX(vec3 v, float a)
{
	return vec3(v.x, cos(a) * v.y - sin(a) * v.z, sin(a) * v.y + cos(a) * v.z);
}

float sceneDist(vec3 p)
{
    return wineGlass(p);
}

vec3 sceneNorm(vec3 p)
{
    float dist = sceneDist(p);
    return normalize(vec3(sceneDist(p + EPS.xyz) - dist, sceneDist(p + EPS.zxy) - dist, sceneDist(p + EPS.yzx) - dist));
}

vec3 sceneColour(vec3 p, vec3 eye)
{
    vec3 n = sceneNorm(p), lpos = vec3(5.0, 5.0, 5.0);
    vec3 ldir = normalize(lpos - p);
    
    vec3 diff = vec3(1.0, 0.6, 0.2), spec = vec3(1.0);
    vec3 r = reflect(normalize(p - eye), n);
    
    float a = (snoise(p * 10.0) + snoise(p * 20.0) * 0.5) / 1.5;
    
    return  (0.95 + a * 0.05) * diff * max(0.0, 0.5 + dot(ldir, n) * 0.5) +
            (0.7 + a * 0.3) * spec * pow(max(0.0, dot(r, ldir)), 10.0);
}


void main( void ) {

	vec3 rd = vec3(0.0, 0.0, 1.0);
	vec3 ro = vec3(0.0, 0.0, -5.0);

	rd.xy = vec2(gl_FragCoord.xy / resolution.xy - 0.5) * vec2(resolution.x / resolution.y, 1.0);

	float angle_x = (mouse.y) * 6.0, angle_y = (mouse.x - 0.5) * 6.0;

	ro = rotateX(rotateY(ro, angle_y), angle_x);
	rd = rotateX(rotateY(rd, angle_y), angle_x);

	gl_FragColor.a = 1.0;
	rd = normalize(rd);

	vec3 eye = ro;

    	int hit_id = 0;
    
	for(int i = 0; i < 60; ++i)
	{
		float dist = sceneDist(ro);

		if(dist < 0.01)
		{
            		hit_id = 1;
			break;
		}

		ro += rd * dist;

		if(distance(ro, eye) > 8.0)
			break;
	}

    gl_FragColor.rgb = (hit_id == 1) ? sceneColour(ro, eye) : vec3(0.0);
}
