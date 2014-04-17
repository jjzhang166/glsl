#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;
//added some of that feedback bumpmap jazz.-gtoledo3
// Start simplex noise

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
	
	
	vec4 permute(vec4 x) {
	     return mod(((x*34.0)+1.0)*x, 289.0);
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
	  i = mod(i,289.0);
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

// End simplex noise


vec3 nc(vec2 a, float f){
	float x = a.x;
	float y = a.y;
	x *= f;
	y *= f;
	float z = time*0.01*f;
	x += z*2.0;
	y += z*2.0;
	
	float x2 = x;
	float y2 = y*0.8-z*0.6;
	float z2 = z*0.8+y*0.5;
	
	float b = snoise(vec3(x2,y2,z2));
	
	return vec3(
		b+(fract(f*0.245325435)-0.5)*0.01,
		b+(fract(f*0.174534534)-0.5)*0.1,
		b+(fract(f*0.724342356)-0.5)*0.1
	)+1.0;
}

void main( void ) {
	vec2 uv = gl_FragCoord.xy/resolution;

	vec2 position = vec2( gl_FragCoord.x / resolution.x - 0.5, (gl_FragCoord.y - resolution.y) / resolution.x )+1.2;
	vec3 c1 = nc(position, 3.0);
	vec3 c2 = nc(vec2(position.x*0.5-position.y*0.85, position.y*0.5+position.x*0.85), 5.0);
	vec3 c3 = nc(vec2(position.x*0.5+position.y*0.85, position.y*0.5-position.x*0.85), 8.0);
	vec3 c4 = nc(vec2(position.x*0.8+position.y*0.6, position.y*0.8-position.x*0.6), 13.0);
	vec3 c5 = nc(vec2(position.x*0.8-position.y*0.6, position.y*0.8+position.x*0.6), 21.0);
	vec3 c6 = nc(vec2(-position.x*0.8+position.y*0.6, -position.y*0.8-position.x*0.6), 34.0);
	vec3 c7 = nc(vec2(-position.x*0.8-position.y*0.6, -position.y*0.8+position.x*0.6), 55.0);

	vec3 ca = max(max(max(c1,c2),max(c3,c4)),max(max(c5, c6), c7));
	vec3 cb = max(max(max(sign(ca-c1)*c1,sign(ca-c2)*c2),max(sign(ca-c3)*c3,sign(ca-c4)*c4)),max(max(sign(ca-c5)*c5,sign(ca-c6)*c6),sign(ca-c7)*c7));
	vec3 cc = max(max(max(sign(cb-c1)*c1,sign(cb-c2)*c2),max(sign(cb-c3)*c3,sign(cb-c4)*c4)),max(max(sign(cb-c5)*c5,sign(cb-c6)*c6),sign(cb-c7)*c7));
	vec3 cd = max(max(max(sign(cc-c1)*c1,sign(cc-c2)*c2),max(sign(cc-c3)*c3,sign(cc-c4)*c4)),max(max(sign(cc-c5)*c5,sign(cc-c6)*c6),sign(cc-c7)*c7));

	gl_FragColor = vec4(vec3(cd-.9), 1.0 );
	// "bumpmapping" @Flexi23
	vec2 d = 2./resolution;
	float dx = texture2D(backbuffer, uv + vec2(-1.,0.)*d).x - texture2D(backbuffer, uv + vec2(1.,0.)*d).x ;
	float dy = texture2D(backbuffer, uv + vec2(0.,-1.)*d).x - texture2D(backbuffer, uv + vec2(0.,1.)*d).x ;
	
	d = vec2(dx,dy)*resolution/resolution.x*2.;
	gl_FragColor.z = pow(clamp(.5-.75*length(uv  - vec2(mouse.x,mouse.y) + d),0.0,1.),2.5);
	gl_FragColor.y = gl_FragColor.z*.5 + gl_FragColor.x*.1;

	gl_FragColor *=10.25;


}


