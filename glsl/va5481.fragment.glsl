#ifdef GL_ES
precision mediump float;
#endif

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



///


float gauss(float x, float u) {
	return pow(2.718, -(x*x/2.0*u*u));
}

float rect(vec2 a, vec2 b, float u) {
	vec2 position = ( gl_FragCoord.xy / resolution.yy );
	vec2 da = a - position;
	vec2 db = b - position;
	float inside = max(0.0, -(sign(da.x * db.x) + sign(da.y * db.y)));
	float dist = 1000000.0;
	if(sign(da.y * db.y) < 0.0) {
		dist = min(dist, abs(da.x));
		dist = min(dist, abs(db.x));		

	}
	if(sign(da.x * db.x) < 0.0) {
		dist = min(dist, abs(da.y));
		dist = min(dist, abs(db.y));
	}
	dist = min(dist, length(da));
	dist = min(dist, length(db));
	dist = min(dist, length(vec2(a.x,b.y)-position));
	dist = min(dist, length(vec2(b.x,a.y)-position));
	
	return max(gauss(dist, u), min(inside,1.0));
}


vec4 drawRect(vec2 a, vec2 b, vec4 colin) {
	vec2 off = vec2(0.005,-0.005);
	float col = rect(a - off, b - off, 90000.0);
	float cols = 1.0 - rect(a + off, b + off, 1.0 / off.x);
	cols = cols + 0.2;
	if(col > 0.0001) {
		return vec4( col, 0.0, 0.0, 1.0 );
	}
	else {
		return colin * cols;
	}
}

void main( void ) {
	vec4 col = vec4(1.0, 1.0, 1.0, 1.0);
	vec2 v = vec2(1.,1.);
	for(int i = 6; i > 0; i--) {
		float f1 = snoise(vec2(cos(time),sin(time) ));
		float f2 = snoise(vec2(cos(time),sin(time) ));
		float r = snoise(vec2(cos(time),sin(time) ));
		float g = snoise(vec2(cos(time),sin(time) ));
		float b = snoise(vec2(cos(time),sin(time) ));

		vec2 off = vec2(cos(float(i)), sin(float(i)))/6.0;
                off  = vec2(off.x * f1 * 3.,off.y * f2 * 2.);
		col = drawRect(vec2(0.6, 0.4) + off, vec2(0.8, 0.6) + off, col);
                if (col.r > 0.1) {
                col.r += sin(r);
                col.g += sin(g);
                col.b += sin(b);
		}
	}
	gl_FragColor = vec4(col.r, col.g,col.b,1.);
}