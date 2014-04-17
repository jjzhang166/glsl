// by rotwang

#ifdef GL_ES
precision mediump float;
#endif
//getting this to compile on my gpu. -gt
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
const float PI = 3.1415926535;

float max3(float a,float b,float c)
{
	return max(a, max(b,c));
}



float rect( vec2 p, vec2 b, float smooth )
{
	vec2 v = abs(p) - b;
  	float d = length(max(v,0.0));
	return 1.0-pow(d, smooth);
}



// --------------------- START of SIMPLEX NOISE
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

// --------------------- END of SIMPLEX NOISE


void main( void ) {

	vec2 unipos = (gl_FragCoord.xy / resolution);
	vec2 pos = unipos*2.0-1.0;
	pos.x *= resolution.x / resolution.y;

	float flash = sin(time*0.001);
	float uflash = flash*0.5+0.5;
	
	
	
	// scroll
	//pos.x -= sin(time*0.5)*1.0;
	
	float d1 = rect(pos - vec2(-0.3,0.0), vec2(0.1,1), 0.05*(1.+0.5*sin(time*3.))); 
	vec3 clr1 = vec3(0.2,0.6,1.0) *d1; 
	
	float d2 = rect(pos - vec2(0.0,0.0), vec2(snoise(vec2(0.1,1)), snoise(vec2(cos(time)+pos.y,sin(time) * pos.x))), 0.05*(1.+0.5*sin(time*3.))); 
	vec3 clr2 = vec3(0.6,0.99,0.2) *d2; 
        float fff = sin(time);
	fff = snoise(vec2(pos.x, sin(time)));
	float d3 = rect(fff+ pos - vec2(0.3,0.0), vec2(0.1,1), uflash*0.1*(1.+0.5*sin(time*3.))); 
	vec3 clr3 = vec3(1.0,0.0,0.2) *0.75*d3 + (0.8*flash); 
	
	float d4 = rect(pos-vec2(1.0,snoise(vec2(pos.y, pos.x)) ),vec2(cos(snoise(vec2(pos.y, pos.x))), cos(pos.x)),.01*(1.+0.5*sin(time*3.)));
	vec3 clr4 = vec3(d4);
	
	
	vec3 clr = vec3(clr1+clr2+clr3+clr4);
	gl_FragColor = vec4( vec3(clr) , 1.0 );

}