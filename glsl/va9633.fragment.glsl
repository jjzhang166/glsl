#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float dMax = 128.0;

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

float terrain( vec2 p, int octaves ) {
	
	float h = 0.0;
	float w = 0.5;
	float m = 0.2;
	for (int i=0; i<16; i++) {
		if (i<octaves) {
			h += w * snoise(p * m);
			w *= 0.5;
			m *= 2.0;
		}
		else break;
	}
	return h;
}

vec2 map ( vec3 p, int octaves ) {
	
	float dMin = dMax; // nearest intersection
	float d; // distance to next object
	float mID = -1.0; // material ID
	
	// terrain
	float h = terrain(p.xz, octaves);
	d = p.y - (h);
	if (d<dMin) { 
		dMin = d;
		mID = 0.;
	}
	return vec2(dMin, mID);
}

vec2 castRay( vec3 ro, vec3 rd) {
	float p = 0.001; // precision
	float t = 0.0; // distance
	float h = p * 2.0; // step size
	float m = -1.0;
	for (int i=0; i<48; i++) {
		if (abs(h)>p || t<dMax ) {
			t += h; // next step
			vec2 res = map(ro + rd*t, 2); // get nearest intersection
			h = res.x; // get distance
			m = res.y; // get material
		} 
		else break;
	}
	if (t>dMax) m = -1.0; // if we found no interstion, material ID is -1.0;
	return vec2(t, m);
}

vec3 calcNormal( vec3 p, int octaves) {
	vec3 eps = vec3(0.0001, 0.0, 0.0);
	return normalize( vec3(map(p+eps.xyy, octaves).x - map(p-eps.xyy, octaves).x,
			       map(p+eps.yxy, octaves).x - map(p-eps.yxy, octaves).x,
			       map(p+eps.yyx, octaves).x - map(p-eps.yyx, octaves).x) );
}

vec3 render( vec3 ro, vec3 rd ) {
	vec3 color = vec3(0.0);
	vec2 res = castRay(ro, rd);
	
	// mat -1 = nothing
	if (res.y < -0.5 ) { return color; }
	
	vec3 pos = ro + rd*res.x;
	vec3 nor = calcNormal(pos, 4);
	vec3 lPos = normalize( vec3(-0.5, 0.5, 0.5) ); // light position
	
	// mat 0 = terrain
	if (res.y > -0.5) {
		float lAmb = clamp( 0.5 + 0.5 * nor.y, 0.0, 1.0); // ambient
		float lDif = clamp( dot( nor, lPos ), 0.0, 1.0); // diffuse
		
		color += vec3(0.4, 0.1, 0.1);
		//color += 0.2 * lAmb * vec3(0.5, 0.5, 0.5);
		color += 1.2 * lDif * vec3(1.0, 0.9, 0.7);
	}
		
	return color;
}

void main( void ) {

	vec2 pos = 2.0 * ( gl_FragCoord.xy / resolution.xy ) - 1.0; // bound screen coords to [0, 1]
	pos.x *= resolution.x / resolution.y; // correct for aspect ratio
	
	// camera
	vec3 cUp = vec3(0., 1., 0.); // up 
	vec3 cLook = vec3(0.0); // lookAt
	float r = 6.;
	float x = r*cos(0.05*time);
	float y = 4.0;//*sin(0.33*time);
	float z = 5.0;// * r*sin(0.1*time);
	vec3 cPos = vec3(x, y, z); // position
	
	// camera matrix
	vec3 ww = normalize( cLook-cPos ); // lookAt - position
	vec3 uu = normalize( cross(ww, cUp) );
	vec3 vv = normalize( cross(uu, ww) );
	
	vec3 rd = normalize( pos.x*uu + pos.y*vv + 2.0*ww );
	
	// render
	vec3 color = render(cPos, rd);
	

	gl_FragColor = vec4( color, 0.0 );

}