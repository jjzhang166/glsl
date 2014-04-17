//updated by Yue Hue and Ashima

// Sunset on the sea v.1.0.1 - Ray Marching & Ray Tracing experiment by Riccardo Gerosa aka h3r3 
// Blog: http://www.postronic.org/h3/ G+: https://plus.google.com/u/0/117369239966730363327 Twitter: @h3r3 http://twitter.com/h3r3
// More information about this shader can be found here: http://www.postronic.org/h3/pid65.html
// This GLSL shader is based on the work of T Whitted, JC Hart, K Perlin, I Quilez and many others
// This shader uses a Simplex Noise implementation by and I McEwan, A Arts (more info below)
// If you modify this code please update this header

precision highp float;

const bool USE_MOUSE = false; // Set this to true for God Mode :)

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
const float PI = 3.14159265;
const float MAX_RAYMARCH_DIST = 150.0;
const float MIN_RAYMARCH_DELTA = 0.00015; 
const float GRADIENT_DELTA = 0.015;
float waveHeight1 = 0.05;
float waveHeight2 = 0.04;
float waveHeight3 = 0.001;
vec3 sphereCenter = vec3(-0.5,-2.0,10.5);
float spherePosx = -0.1;

// --------------------- START of SIMPLEX NOISE
//
// Description : Array and textureless GLSL 2D simplex noise function.
// 

vec3 mod289(vec3 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
//      Author : Ian McEwan, Ashima Arts.
//  Maintainer : ijm
//     Lastmod : 20110822 (ijm)
//     License : Copyright (C) 2011 Ashima Arts. All rights reserved.
//               Distributed under the MIT License. See LICENSE file.
//               https://github.com/ashima/webgl-noise
}

vec2 mod289(vec2 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec4 _mod289(vec4 x)
{
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec3 _mod289(vec3 x)
{
    return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec2 _mod289(vec2 x) 
{
    return x - floor(x * (1.0 / 289.0)) * 289.0;
}

float _mod289(float x)
{
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
vec4 _taylorInvSqrt(vec4 r)
{
    return 1.79284291400159 - 0.85373472095314 * r;
}
vec4 _permute(vec4 x) {
     return _mod289(((x*34.0)+1.0)*x);
}
float dBox( vec3 p, vec3 b )
{
	vec3 d = abs(p) - b;
	return min(max(d.x,max(d.y,d.z)),0.0) + length(max(d,0.0));
}

float d2Box( vec3 p, vec3 b )
{
	float box1 = dBox( p + vec3( 0.5, 0.0, 0.0 ), b );
	float box2 = dBox( p - vec3( 0.5, 0.0, 0.0 ) , b );
	return min(box1, box2);
}

float dTorus( vec3 p, vec2 t )
{
  vec2 q = vec2(length(p.xz)-t.x,p.y);
  return length(q)-t.y;
}

float snoise(vec3 v)
{ 
    const vec2  C = vec2(1.0/6.0, 1.0/3.0) ;
    const vec4  D = vec4(0.0, 0.5, 1.0, 2.0);

    // First corner
    vec3 i  = floor(v + dot(v, C.yyy) );
    vec3 x0 =   v - i + dot(i, C.xxx) ;

    // Other corners
    vec3 g = step(x0.yzx, x0.xyz);
    vec3 l = 1.0 - g;
    vec3 i1 = min( g.xyz, l.zxy );
    vec3 i2 = max( g.xyz, l.zxy );

    //   x0 = x0 - 0.0 + 0.0 * C.xxx;
    //   x1 = x0 - i1  + 1.0 * C.xxx;
    //   x2 = x0 - i2  + 2.0 * C.xxx;
    //   x3 = x0 - 1.0 + 3.0 * C.xxx;
    vec3 x1 = x0 - i1 + C.xxx;
    vec3 x2 = x0 - i2 + C.yyy; // 2.0*C.x = 1/3 = C.y
    vec3 x3 = x0 - D.yyy;      // -1.0+3.0*C.x = -0.5 = -D.y

    // Permutations
    i = _mod289(i); 
    vec4 p = _permute( _permute( _permute( 
                i.z + vec4(0.0, i1.z, i2.z, 1.0 ))
              + i.y + vec4(0.0, i1.y, i2.y, 1.0 )) 
              + i.x + vec4(0.0, i1.x, i2.x, 1.0 ));

    // Gradients: 7x7 points over a square, mapped onto an octahedron.
    // The ring size 17*17 = 289 is close to a multiple of 49 (49*6 = 294)
    float n_ = 0.142857142857; // 1.0/7.0
    vec3  ns = n_ * D.wyz - D.xzx;

    vec4 j = p - 49.0 * floor(p * ns.z * ns.z);  //  mod(p,7*7)

    vec4 x_ = floor(j * ns.z);
    vec4 y_ = floor(j - 7.0 * x_ );    // mod(j,N)

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
    vec4 norm = _taylorInvSqrt(vec4(dot(p0,p0), dot(p1,p1), dot(p2, p2), dot(p3,p3)));
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


// --------------------- END of SIMPLEX NOISE

float sdSphere( vec3 p, float s )
{
  return length(p)-s;
}


float map(vec3 p, inout bool sphere) {

	float wave = (0.5 + waveHeight1 + waveHeight2 + waveHeight3) 
		+ snoise(vec2(p.x + time * 0.4, p.z + time * 0.6)) * waveHeight1
		+ snoise(vec2(p.x * 1.6 - time * 0.4, p.z * 1.7 - time * 0.6)) * waveHeight2
	  	+ snoise(vec2(p.x * 6.6 - time * 1.0, p.z * 2.7 + time * 1.176)) * waveHeight3;

	float dwater = p.y + wave;
	float noise = 0.01*snoise( p*2.0 + time );
	 // warpping xz plane
	float c = 1.0;
	  p.x = mod(p.x,c)-c/2.0;
	  p.z = mod(p.z,c)-c/2.0;
        // p.x+=noise;
	 p.y += 0.61;// +0.09*sin(time);
	p.z+=noise;
	
	
	

	float dsphere = sdSphere(p, 0.1)+ noise;//sdSphere(p, 0.1);	
	if(dsphere<dwater)
	   sphere = true;
	else
	  sphere = false;  
	
	return min(dsphere, dwater);
}

vec3 gradientNormalFast(vec3 p, float map_p, inout bool sphere) {
    return normalize(vec3(
        map_p - map(p - vec3(GRADIENT_DELTA, 0, 0),sphere),
        map_p - map(p - vec3(0, GRADIENT_DELTA, 0),sphere),
        map_p - map(p - vec3(0, 0, GRADIENT_DELTA),sphere)));
}

float intersect(vec3 p, vec3 ray_dir, out float map_p, out int iterations, inout bool sphere) {
	iterations = 0;
	if (ray_dir.y >= 0.0) { return -1.0; } // to see the sea you have to look down
	
	float distMin = (- 0.5 - p.y) / ray_dir.y;
	float distMid = distMin;
	for (int i = 0; i < 20; i++) {
		//iterations++;
		distMid += max(0.05 + float(i) * 0.002, map_p);
		map_p = map(p + ray_dir * distMid,sphere);
		if (map_p > 0.0) { 
			distMin = distMid + map_p;
		} else { 
			float distMax = distMid + map_p;
			// interval found, now bisect inside it
			for (int i = 0; i < 10; i++) {
				//iterations++;
				distMid = distMin + (distMax - distMin) / 2.0;
				map_p = map(p + ray_dir * distMid,sphere);
				if (abs(map_p) < MIN_RAYMARCH_DELTA) return distMid;
				if (map_p > 0.0) {
					distMin = distMid + map_p;
				} else {
					distMax = distMid + map_p;
				}
			}
			return distMid;
		}
	}
	return distMin;
}

void main( void ) {
	vec3 sphereColor = vec3(0.0,0.0,0.0);
	float splash = USE_MOUSE ? 1.0 : 0.0;
	float posMouse  = mouse.x;
	float waveHeight = USE_MOUSE ? mouse.x * 5.0 : cos(time * 0.03) * 1.2 + 1.6;
	waveHeight1 *= waveHeight;
	waveHeight2 *= waveHeight;
	waveHeight3 *= waveHeight;
	
	bool sphere = false;
	
	
	float t = -1.0;
	
	
	vec2 position = vec2((gl_FragCoord.x - resolution.x / 2.0) / resolution.y, (gl_FragCoord.y - resolution.y / 2.0) / resolution.y);
	
	vec3 ray_start = vec3(0, 0.2, -2);
	vec3 ray_dir = normalize(vec3(position,0) - ray_start);
	
	//ray_start.y = cos(time * 0.5) * 0.2 - 0.25 + sin(time * 2.0) * 0.05;
	vec3 light_pos = vec3(5.0,0.0,-2.0);
	const float dayspeed = 0.04;
	float subtime = max(-0.16, sin(time * dayspeed) * 0.2);
	float middayperc = USE_MOUSE ? mouse.y * 0.3 - 0.15 : max(0.0, 0.35);
	vec3 light1_pos = vec3(0.0, middayperc * 200.0, USE_MOUSE ? 200.0 : cos(subtime * dayspeed) * 200.0);
	float sunperc = pow(max(0.0, min(dot(ray_dir, normalize(light1_pos)), 1.0)), 190.0 + max(0.0,light1_pos.y * 4.3));
	vec3 suncolor = (1.0 - max(0.0, middayperc)) * vec3(1.5, 1.2, middayperc + 0.5) + max(0.0, middayperc) * vec3(1.0, 1.0, 1.0) * 4.0;
	vec3 skycolor = vec3(middayperc + 0.8, middayperc + 0.7, middayperc + 0.5);
	vec3 skycolor_now = suncolor * sunperc + (skycolor * (middayperc * 1.6 + 0.5)) * (1.0 - sunperc);
	vec4 color = vec4(0.0, 0.0, 0.0, 1.0);
	float map_p;
	int iterations;
	vec3 sphereNormal = vec3(0,0,0);
	vec3 ptofIntersection = vec3(0,0,0);
	
	
		float dist = intersect(ray_start, ray_dir, map_p, iterations,sphere);
		if (dist > 0.0) {
			vec3 p = ray_start + ray_dir * dist;
			vec3 light1_dir = normalize(light1_pos - p);
			vec3 n = gradientNormalFast(p, map_p,sphere);
			vec3 ambient = skycolor_now * 0.1;
			vec3 diffuse1 = vec3(1.1, 1.1, 0.6) * max(0.0, dot(light1_dir, n)  * 2.8);
			vec3 r = reflect(light1_dir, n);
			vec3 specular1 = vec3(1.5, 1.2, 0.6) * (0.8 * pow(max(0.0, dot(r, ray_dir)), 200.0));	    
			float fog = min(max(p.z * 0.07, 0.0), 1.0);
			vec4 tempColor = color;
			if(sphere){
				//tempColor.rgb = (vec3(1.0,0.1,0.3) * diffuse1 + specular1 + ambient)  * (1.0 - fog) + skycolor_now * fog;		
				color.rgb = (vec3(1.0,0.1,0.3) * diffuse1 + specular1 + ambient)  * (1.0 - fog) + skycolor_now * fog;		
			}else
				color.rgb = (vec3(0.6,0.6,1.0) * diffuse1 + specular1 + ambient)  * (1.0 - fog) + skycolor_now * fog;
			//color = vec4(mix(tempColor,color,0.1));
		} else {
			color.rgb = skycolor_now.rgb;
		}
	
	
	gl_FragColor = color;
}