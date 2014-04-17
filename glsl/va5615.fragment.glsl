#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

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

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	vec2 pixel = 1.0/resolution;
	
	vec4 color = vec4(0.0,0.0,0.0,1.0);
	
	if (position.y < pixel.y) {
		vec4 c1 = vec4(1.0, 0.5, 0.2, 1.0);
		vec4 c2 = vec4(0.6, 1.0, 0.2, 1.0);
		vec4 c3 = vec4(0.4, 0.5, 0.8, 1.0);
		float i = 0.0;
		float j = 0.0;
		float k = 0.0;
		
		vec2 p = vec2(position.x, time);
		p.x += time;
		i += 1.0    *snoise(p); p *= 2.0;
		i += 0.5    *snoise(p); p *= 2.0;
		i += 0.25   *snoise(p); p *= 2.0;
		i += 0.125  *snoise(p); p *= 2.0;
		i += 0.0625 *snoise(p); p *= 2.0;		
		color += c1*i;

		p = vec2(position.x, time+0.1);
		p.x += cos(time);
		j += 1.0    *snoise(p); p *= 2.0;
		j += 0.5    *snoise(p); p *= 2.0;
		j += 0.25   *snoise(p); p *= 2.0;
		j += 0.125  *snoise(p); p *= 2.0;
		j += 0.0625 *snoise(p); p *= 2.0;		
		color += c2*j;
		
		p = vec2(position.x+0.1, time+0.05);
		p.x += sin(time);
		k += 1.0    *snoise(p); p *= 2.0;
		k += 0.5    *snoise(p); p *= 2.0;
		k += 0.25   *snoise(p); p *= 2.0;
		k += 0.125  *snoise(p); p *= 2.0;
		k += 0.0625 *snoise(p); p *= 2.0;
		color += c3*k;
	} else {
		color = texture2D(backbuffer, position + pixel * vec2(0.0, -4.)) - vec4(0.00623,0.013724,0.010234,0.0);
	}
	
	gl_FragColor = vec4(color);
}