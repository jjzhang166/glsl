#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float dMax = 32.0;

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
	float w = 1.0;
	float m = 0.2;
	for (int i=0; i<16; i++) {
		if (i<octaves) {
			h += w * snoise(p * m);
			w *= 0.5;
			m *= 2.0;
		}
		else break;
	}
	
	h = 0.5 * (h+1.0);

	return h;
}

vec2 map ( vec3 p, int octaves ) {
	
	float dMin = dMax; // nearest intersection
	float d; // distance to next object
	float mID = -1.0; // material ID
	
	// terrain
	float h = terrain(p.xz, octaves);
	h *= smoothstep(-0.2, 0.8, h);
	d = p.y - h;
	if (d<dMin) { 
		dMin = d;
		mID = 0.0;
	}
	
	/* water
	d = 100.0*p.y + 0.15;
	if (d<dMin) {
		dMin = d;
		mID = 1.0;	
	} */

	return vec2(dMin, mID);
}

vec2 castRay( vec3 ro, vec3 rd, int octaves) {
	float p = 0.001; // precision
	float t = 0.0; // distance
	float h = p * 2.0; // step size
	float m = -1.0;
	for (int i=0; i<32; i++) {
		if (abs(h)>p || t<dMax ) {
			t += h; // next step
			vec2 res = map(ro + rd*t, octaves); // get nearest intersection
			h = res.x; // get distance
			m = res.y; // get material
		} 
		else break;
	}
	if (t>dMax) m = -1.0; // if we found no interstion, material ID is -1.0;
	return vec2(t, m);
}

vec3 calcNormal( vec3 p, int octaves) {
	const vec3 eps = vec3(0.001, 0.0, 0.0);
	return normalize( vec3(map(p+eps.xyy, octaves).x - map(p-eps.xyy, octaves).x,
			       map(p+eps.yxy, octaves).x - map(p-eps.yxy, octaves).x,
			       map(p+eps.yyx, octaves).x - map(p-eps.yyx, octaves).x) );
}

float shadow ( vec3 ro, vec3 rd, float tMin, float tMax, float k ) {
	float res = 1.0; // result
	float t = tMin; // step
	for (int i=0; i<8; i++) {
		if (t<tMax) {
			float d = map(ro+rd*t, 10).x; // get nearest intersection
			res = min(res, k*d/t); 
			t += clamp(d, 0.01, 0.05); // next step
		}
		else break;
	}
	return clamp(1.0-res, 0.0, 1.0);
}

vec3 render( vec3 ro, vec3 rd ) {
	vec3 color = vec3(0.5,0.6,0.6);
	vec2 res = castRay(ro, rd, 4);
	
	// mat -1 = nothing
	if (res.y < -0.5) return color;
	
	vec3 pos = ro + rd*res.x;
	vec3 nor = calcNormal(pos, int(max(2.0, 10.0-res.x*res.x/dMax)) ); // pseudo-LOD
	vec3 lPos = normalize( vec3(-0.5, 0.5, 0.5) ); // light position
	float lAmb = clamp( 0.5 + 0.5 * nor.y, 0.0, 1.0); // ambient
	float lDif = clamp( dot( nor, lPos ), 0.0, 1.0); // diffuse
	
	// mat 0 = terrain

	if (res.y > -0.5 && res.y < 0.5) {
		float n = 2.0*(snoise(pos.xy*vec2(1.0, 10.0))+1.0); // rocks have layers
		color = mix( vec3(0.3, 0.3, 0.3), vec3(0.45, 0.4, 0.35), smoothstep(0.6, 0.8, nor.y) ); // rocks
		color = mix( color, (0.15*n)*vec3(0.55, 0.55, 0.4), smoothstep(0.4, 0.8, nor.y) ); // layers
		color = mix( color, vec3(0.25, 0.35, 0.15), smoothstep(0.9, 1.0, nor.y) ); // grass
		color += (0.2*lAmb) * vec3(0.9, 1.0, 1.0);
		color *= (1.5*lDif) * vec3(0.9, 1.0, 1.0);	
		
		float s = shadow(pos, lPos, 0.02, 2.0, 0.5);
		color -= 0.1*s;
	}
	
	// fog
	float fog = exp(-(0.005*res.x*res.x));
	color = mix(vec3(0.5, 0.6, 0.6), color,  fog);
		
	return color;
}

void main( void ) {

	vec2 pos = 2.0 * ( gl_FragCoord.xy / resolution.xy ) - 1.0; // bound screen coords to [0, 1]
	pos.x *= resolution.x / resolution.y; // correct for aspect ratio

	
	// camera
	float x = 0.0 + (0.3*time);
	float y = 2.0;//*sin(0.33*time);
	float z = 3.0*sin(0.1*time);
	vec3 cPos = vec3(x, y, z); // position
	cPos.y = terrain(cPos.xz, 2) + 1.0;
	
	vec3 cUp = vec3(0., 1., 0.); // up 
	vec3 cLook = vec3(cPos.x + 1.0, cPos.y*0.8, 0.0); // lookAt
	
	// camera matrix
	vec3 ww = normalize( cLook-cPos ); // lookAt - position
	vec3 uu = normalize( cross(ww, cUp) );
	vec3 vv = normalize( cross(uu, ww) );
	
	vec3 rd = normalize( pos.x*uu + pos.y*vv + 2.0*ww );
	
	// render
	vec3 color = render(cPos, rd);
	

	gl_FragColor = vec4( color, 0.0 );

}