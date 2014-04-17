// Planet
// Awd
// @AlexWDunn

#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;
uniform float zoom;

#define saturate(oo) clamp(oo, 0.0, 1.0)

// Quality Settings
#define MarchSteps 6

// Scene Settings
#define ExpPosition vec3(0.0)
#define Radius 3.0

// Stars
#define StarTwinkleSpeed 0.0
#define StarBrightness 20.0

// Noise Settings
#define NoiseSteps 4
#define NoiseAmplitude 0.1
#define NoiseFrequency 2.2

// Colour Gradient
#define Color1 vec4(0.0, 0.0, 0.5, 1.0)
#define Color2 vec4(0.0, 0.1, 0.8, 1.0)
#define Color3 vec4(0.1, 0.8, 0.20, 1.0)
#define Color4 vec4(0.05, 0.2, 0.02, 1.0)

// Lighting
#define LightDirection vec3(0.0, 0.0, 1.0)
#define LightColour vec4(0.9, 1.0, 0.4, 1.0)
#define LightIntensity 1.1

//============================================BEGIN NOISE===========================================//
// Description : Array and textureless GLSL 2D/3D/4D simplex
//               noise functions.
//      Author : Ian McEwan, Ashima Arts.
//  Maintainer : ijm
//     Lastmod : 20110822 (ijm)
//     License : Copyright (C) 2011 Ashima Arts. All rights reserved.
//               Distributed under the MIT License. See LICENSE file.
//               https://github.com/ashima/webgl-noise
//

float rand(vec2 co)
{
	// implementation found at: lumina.sourceforge.net/Tutorials/Noise.html
	return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 434658.5453116487577816842168767168087910388737310);
}

vec3 mod289(vec3 x) { return x - floor(x * (1.0 / 289.0)) * 289.0; }
vec4 mod289(vec4 x) { return x - floor(x * (1.0 / 289.0)) * 289.0; }
vec4 permute(vec4 x) { return mod289(((x*34.0)+1.0)*x); }
vec4 taylorInvSqrt(vec4 r){ return 1.79284291400159 - 0.85373472095314 * r; }

float snoise(vec3 v)
{
	const vec2  C = vec2(1.0/6.0, 1.0/3.0);
	const vec4  D = vec4(0.0, 0.5, 1.0, 2.0);

	// First corner
	vec3 i  = floor(v + dot(v, C.yyy));
	vec3 x0 = v - i + dot(i, C.xxx);

	// Other corners
	vec3 g = step(x0.yzx, x0.xyz);
	vec3 l = 1.0 - g;
	vec3 i1 = min(g.xyz, l.zxy);
	vec3 i2 = max(g.xyz, l.zxy);
	vec3 x1 = x0 - i1 + C.xxx;
	vec3 x2 = x0 - i2 + C.yyy; // 2.0*C.x = 1/3 = C.y
	vec3 x3 = x0 - D.yyy;      // -1.0+3.0*C.x = -0.5 = -D.y

	// Permutations
	i = mod289(i);
	vec4 p = permute( permute( permute( i.z + vec4(0.0, i1.z, i2.z, 1.0)) + i.y + vec4(0.0, i1.y, i2.y, 1.0 )) + i.x + vec4(0.0, i1.x, i2.x, 1.0 ));

	// Gradients: 7x7 points over a square, mapped onto an octahedron.
	// The ring size 17*17 = 289 is close to a multiple of 49 (49*6 = 294)
	float n_ = 0.142857142857; // 1.0/7.0
	vec3  ns = n_ * D.wyz - D.xzx;
	vec4 j = p - 49.0 * floor(p * ns.z * ns.z);  //  mod(p,7*7)

	vec4 x_ = floor(j * ns.z);
	vec4 y_ = floor(j - 7.0 * x_);    // mod(j,N)

	vec4 x = x_ *ns.x + ns.yyyy;
	vec4 y = y_ *ns.x + ns.yyyy;

	vec4 h = 1.0 - abs(x) - abs(y);
	vec4 b0 = vec4(x.xy, y.xy);
	vec4 b1 = vec4(x.zw, y.zw);

	vec4 s0 = floor(b0) * 2.0 + 1.0;
	vec4 s1 = floor(b1) * 2.0 + 1.0;
	vec4 sh = -step(h, vec4(0.0));

	vec4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
	vec4 a1 = b1.xzyw + s1.xzyw * sh.zzww;

	vec3 p0 = vec3(a0.xy, h.x);
	vec3 p1 = vec3(a0.zw, h.y);
	vec3 p2 = vec3(a1.xy, h.z);
	vec3 p3 = vec3(a1.zw, h.w);

	//Normalise gradients
	vec4 norm = taylorInvSqrt(vec4(dot(p0,p0), dot(p1,p1), dot(p2, p2), dot(p3,p3)));

	p0 *= norm.x;
	p1 *= norm.y;
	p2 *= norm.z;
	p3 *= norm.w;

	// Mix final noise value
	vec4 m = max(0.6 - vec4(dot(x0,x0), dot(x1,x1), dot(x2,x2), dot(x3,x3)), 0.0);
	m = m * m;

	return 42.0 * dot( m*m, vec4( dot(p0,x0), dot(p1,x1), dot(p2,x2), dot(p3,x3)));
}
//============================================END NOISE=============================================//


float Turbulence(vec3 position, float minFreq, float maxFreq, float qWidth)
{
	float value = 0.0;
	float cutoff = clamp(0.5/qWidth, 0.0, maxFreq);
	float fade;
	float fOut = minFreq;

	for(int i=NoiseSteps ; i>=0 ; i--)
	{
		if(fOut >= 0.5 * cutoff) break;

		fOut *= 2.0;
		value += abs(snoise(position * fOut))/fOut;
	}

	fade = clamp(2.0 * (cutoff-fOut)/cutoff, 0.0, 1.0);
	value += fade * abs(snoise(position * fOut))/fOut;

	return 1.0-value;
}

// Background methods------------------------------------------
vec3 Stars(float luminosity, float dist, vec3   pos) 
{
	float rand_dist = snoise(vec3(luminosity, dist, 0.0));
	float rand_dist_2 = snoise(vec3(dist));
	float red   = clamp(80.0/255.0 * (dist) , 170.0/255.0, 1.0) * (luminosity);
	float green = clamp(190.0/255.0 * (dist), 170.0/255.0, 1.0) * (luminosity);
	float blue  = clamp(2.0 * dist, 100.0/255.0, 1.0) * (luminosity);
	
	// Background stars
	vec2 coord = vec2(pow(dist, 0.1), acos(abs(dot(pos, pos))) * 0.15915494);
	
	float a = pow((1.0-dist),20.0);
	float t = time*-.01;
	float r = coord.x - (t*StarTwinkleSpeed);
	float c = fract(a+coord.y);
	vec2  p = vec2(r, c*.5)*4000.0; 
	vec2 uv = fract(p)*2.0-1.0;
	float m = clamp((rand(floor(p))-0.9)*StarBrightness, 0.0, 1.0);
	float star =  clamp((1.0-length(uv*2.0))*m*dist, 0.0, 1.0);
	
	return vec3(red+star,green+star,blue+star);
}

vec3 Sun(vec3 v)
{
	vec3 c = mix(vec3(0.0, 0.05, 0.09), vec3(0, 0.0, 0.0), abs(v.y));
	float sun = pow(max(0.0, dot(v, LightDirection)), 200.0);
	c += sun*LightColour.xyz*5.0;
	return c;
}

vec4 Background(vec3 direction, vec2 m)
{
	return vec4(Stars(0.03, length(direction.xy), direction+m.xyy).rgb + Sun(direction), 1.0);
}

// Planet methods-------------------------------------
float SphereDist(vec3 position)
{
	return length(position - ExpPosition) - Radius;
}

vec4 Shade(float distance)
{
	float c1 = saturate(distance*5.0 + 0.5);
	float c2 = saturate(distance*4.0);
	float c3 = saturate(distance*3.0 - 0.5);
	
	vec4 a = mix(Color1,Color2, c1);
	vec4 b = mix(a,     Color3, c2);
	return 	 mix(b,     Color4, c3);
}

float RenderScene(vec3 position, out float distance)
{
	float noise = Turbulence(position * NoiseFrequency, 0.1, 1.5, 0.03) * NoiseAmplitude;
	noise = saturate(abs(noise));
	distance = SphereDist(position) - noise;
		
	distance = min(distance, SphereDist(position) - 0.1);	// sea level
	
	return noise;
}

vec3 CalculateNormal(vec3 position)  
{
	vec2 e = vec2(.0001, -.0001);
	float d1, d2, d3, d4;
	RenderScene(position+e.xyy, d1);
	RenderScene(position+e.yyy, d2);
	RenderScene(position+e.yxy, d3);
	RenderScene(position+e.xxx, d4);
	vec4 o = vec4(d1, d2, d3, d4);
	return (o.wzy+o.xww-o.zxz-o.yyx)/(4.*e.x);
}

float Diffuse(vec3 normal)
{
	return saturate(max(0.0, dot(normal, LightDirection)) * LightIntensity);
}

vec4 AtmosphericScattering(vec3 position, vec3 direction, vec3 normal)
{
	
	float scattering = max(0.0, dot(LightDirection, direction)) / (1.0 - max(0.0, dot(LightDirection, normal)));
	scattering = pow(saturate(scattering), 90.0);
	float invCenter = saturate(length(position)/(Radius + NoiseAmplitude * mix(28.0, 50.0, scattering)));
	float a = 1.0 - pow(invCenter, 2.0);
	return mix(vec4(0.0, 0.0, 1.0, 0.1), vec4(1.0, 1.0, 0.8, a*0.8), scattering);
}

vec4 March(vec3 rayOrigin, vec3 rayStep)
{
	vec3 position = rayOrigin;
	
	float distance;
	float displacement;
	
	for(int step = MarchSteps; step >=0  ; --step)
	{
		displacement = RenderScene(position, distance);
		position += rayStep * distance;
		
		if(distance < 0.05) break;
	}
	
	vec3 normal = CalculateNormal(position);
	vec4 sceneOutput = Shade(displacement) * Diffuse(normal);
	sceneOutput.w = 1.0;
	
	return mix(sceneOutput, AtmosphericScattering(position, normalize(rayStep), normalize(position)), float(distance >= 0.5));
}

bool IntersectSphere(vec3 ro, vec3 rd, vec3 pos, float radius, out vec3 intersectPoint)
{
	vec3 relDistance = (ro - pos);
	
	float b = dot(relDistance, rd);
	float c = dot(relDistance, relDistance) - radius*radius;
	float d = b*b - c;
	
	intersectPoint = ro + rd*(-b - sqrt(d));
	
	return d >= 0.0;
}

void main(void)
{
	vec2 p = (gl_FragCoord.xy / resolution.xy) * 2.0 - 1.0;
	p.x *= resolution.x/resolution.y;

	
	vec2 m = (mouse/resolution) * 2.0 - 1.0;
	m.x *= resolution.x/resolution.y;
	
	float rotx = mouse.y * 4.0;
	float roty = -mouse.x * 10.0;
	float zoom = 10.0;

	// camera
	vec3 ro = zoom * normalize(vec3(cos(roty), cos(rotx), sin(roty)));
	vec3 ww = normalize(vec3(0.0, 0.0, 0.0) - ro);
	vec3 uu = normalize(cross( vec3(0.0, 1.0, 0.0), ww));
	vec3 vv = normalize(cross(ww, uu));
	vec3 rd = normalize(p.x*uu + p.y*vv + 1.5*ww);
	rd *= 2.;

	vec4 col = Background(rd, m);

	vec3 origin;	
	if(IntersectSphere(ro, rd, ExpPosition, Radius + NoiseAmplitude*6.0, origin))
	{
		vec4 sceneOutput = March(origin, rd);
		col = mix(col, sceneOutput, sceneOutput.a);
	}
	
	gl_FragColor = col;
}