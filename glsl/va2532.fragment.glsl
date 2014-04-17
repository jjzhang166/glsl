/*

Set the quality to 4 or 8 for smoother running.

---
Removed abs() from distance function to enable signed distances (and avoid stepping through terrain).
Set step size to 0.9 for 9x faster marching...
Dropped iteration count to sensible number ;)
psonice
*/

//cnoise mashup_gt

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 vCamPos = vec3(sin(-time * 0.125) * 40.0, 8.0 + abs(cos(time * 0.25) * 4.0), cos(-time * 0.125) * 40.0);

float DistTerrains (const in vec3 vPos);

#define SATURATE(v) clamp(v, 0.0, 1.0)

#define EPSILON 0.00000012
#define PI 3.14159265358979323846264
#define PI2 PI * 2.0	

#define uScreenX (1.0 / resolution.x)
vec3 mod289(vec3 x)
{
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec4 mod289(vec4 x)
{
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec4 permute(vec4 x)
{
  return mod289(((x*34.0)+1.0)*x);
}

vec4 taylorInvSqrt(vec4 r)
{
  return 1.79284291400159 - 0.85373472095314 * r;
}

vec3 fade(vec3 t) {
  return t*t*t*(t*(t*6.0-15.0)+10.0);
}

float cnoise(vec3 P)
{
  vec3 Pi0 = floor(P); // Integer part for indexing
  vec3 Pi1 = Pi0 + vec3(1.0); // Integer part + 1
  Pi0 = mod289(Pi0);
  Pi1 = mod289(Pi1);
  vec3 Pf0 = fract(P); // Fractional part for interpolation
  vec3 Pf1 = Pf0 - vec3(1.0); // Fractional part - 1.0
  vec4 ix = vec4(Pi0.x, Pi1.x, Pi0.x, Pi1.x);
  vec4 iy = vec4(Pi0.yy, Pi1.yy);
  vec4 iz0 = Pi0.zzzz;
  vec4 iz1 = Pi1.zzzz;

  vec4 ixy = permute(permute(ix) + iy);
  vec4 ixy0 = permute(ixy + iz0);
  vec4 ixy1 = permute(ixy + iz1);

  vec4 gx0 = ixy0 * (1.0 / 7.0);
  vec4 gy0 = fract(floor(gx0) * (1.0 / 7.0)) - 0.5;
  gx0 = fract(gx0);
  vec4 gz0 = vec4(0.5) - abs(gx0) - abs(gy0);
  vec4 sz0 = step(gz0, vec4(0.0));
  gx0 -= sz0 * (step(0.0, gx0) - 0.5);
  gy0 -= sz0 * (step(0.0, gy0) - 0.5);

  vec4 gx1 = ixy1 * (1.0 / 7.0);
  vec4 gy1 = fract(floor(gx1) * (1.0 / 7.0)) - 0.5;
  gx1 = fract(gx1);
  vec4 gz1 = vec4(0.5) - abs(gx1) - abs(gy1);
  vec4 sz1 = step(gz1, vec4(0.0));
  gx1 -= sz1 * (step(0.0, gx1) - 0.5);
  gy1 -= sz1 * (step(0.0, gy1) - 0.5);

  vec3 g000 = vec3(gx0.x,gy0.x,gz0.x);
  vec3 g100 = vec3(gx0.y,gy0.y,gz0.y);
  vec3 g010 = vec3(gx0.z,gy0.z,gz0.z);
  vec3 g110 = vec3(gx0.w,gy0.w,gz0.w);
  vec3 g001 = vec3(gx1.x,gy1.x,gz1.x);
  vec3 g101 = vec3(gx1.y,gy1.y,gz1.y);
  vec3 g011 = vec3(gx1.z,gy1.z,gz1.z);
  vec3 g111 = vec3(gx1.w,gy1.w,gz1.w);

  vec4 norm0 = taylorInvSqrt(vec4(dot(g000, g000), dot(g010, g010), dot(g100, g100), dot(g110, g110)));
  g000 *= norm0.x;
  g010 *= norm0.y;
  g100 *= norm0.z;
  g110 *= norm0.w;
  vec4 norm1 = taylorInvSqrt(vec4(dot(g001, g001), dot(g011, g011), dot(g101, g101), dot(g111, g111)));
  g001 *= norm1.x;
  g011 *= norm1.y;
  g101 *= norm1.z;
  g111 *= norm1.w;

  float n000 = dot(g000, Pf0);
  float n100 = dot(g100, vec3(Pf1.x, Pf0.yz));
  float n010 = dot(g010, vec3(Pf0.x, Pf1.y, Pf0.z));
  float n110 = dot(g110, vec3(Pf1.xy, Pf0.z));
  float n001 = dot(g001, vec3(Pf0.xy, Pf1.z));
  float n101 = dot(g101, vec3(Pf1.x, Pf0.y, Pf1.z));
  float n011 = dot(g011, vec3(Pf0.x, Pf1.yz));
  float n111 = dot(g111, Pf1);

  vec3 fade_xyz = fade(Pf0);
  vec4 n_z = mix(vec4(n000, n100, n010, n110), vec4(n001, n101, n011, n111), fade_xyz.z);
  vec2 n_yz = mix(n_z.xy, n_z.zw, fade_xyz.y);
  float n_xyz = mix(n_yz.x, n_yz.y, fade_xyz.x); 
  return 1.5 * n_xyz;
}

float surface3 ( vec3 coord ) {
	
	float frequency = 5.548;
	float n = -.4;	
		
	n += 1.0	* abs( cnoise( coord * frequency ) );
	n += 0.5	* abs( cnoise( coord * frequency * 2.0 ) );
	n += 0.25	* abs( cnoise( coord * frequency * 4.0 ) );	
	return n;
}

struct TMaterial {
	vec3 vNormal; // that's all for now...
};


float DistFloor (const in vec3 vPos) {
	float f1 = 10.0 * sin(vPos.z * 0.125) * cos(vPos.x * 0.125); // texture(uTex0, vPos.xz * 0.05).r; // 
	float f2 = vPos.y;
	const float fThickness = 0.0;
	return (f2 - f1) - fThickness;
}

float DistTerrains (const in vec3 vPos) {
	return DistFloor(vPos); // OpUnion(DistWater(vPos), DistFloor(vPos));
}

vec3 NormalCentroidTerrains (const in vec3 vPos, const in float fEpsilon, const in float fLastDist) {
	vec2 vDelta = vec2(fEpsilon, 0);
	return normalize(vec3(
		DistTerrains(vPos + vDelta.xyy) - DistTerrains(vPos - vDelta.xyy),
		DistTerrains(vPos + vDelta.yxy) - DistTerrains(vPos - vDelta.yxy),
		DistTerrains(vPos + vDelta.yyx) - DistTerrains(vPos - vDelta.yyx)
	));
}

void RaymarchTerrains (inout vec3 vPos, const in vec3 vDir, const in float fMaxDist, inout float fNearLimit, inout float fTotalDist, out TMaterial tMat) {
	const vec3 vPlaneTerrain = vec3(-10.0 - 1.0, 10.0 + 1.0, 0.0); // bounding plane: above terrains' highest and below its lowest elevation
	const vec3 vPlaneWater = vec3(-9.0 - 0.1, 9.0 + 0.1, 0.0); // not used right now
	bvec2 bAboveBelow = bvec2(step(vPlaneTerrain.g, vCamPos.y), step(vCamPos.y, vPlaneTerrain.r));

	if (!((bAboveBelow.r && (vDir.y >= 0.0)) || (bAboveBelow.g && (vDir.y <= 0.0)))) { // only march if ray above terrain goes down or ray below terrain goes up
		// intersect with bounding planes
		const vec3 vPlaneNormal = vec3(0.0, 1.0, 0.0);
		float fInvDotNormal = 1.0 / dot(vPlaneNormal, vDir + EPSILON);
		vec2 vPlaneTerrainDists = fInvDotNormal * vec2(dot(vPlaneNormal, vPlaneTerrain.brb - vCamPos), dot(vPlaneNormal, vPlaneTerrain.bgb - vCamPos));
		vec2 vPlaneWaterDists = fInvDotNormal * vec2(dot(vPlaneNormal, vPlaneWater.brb - vCamPos), dot(vPlaneNormal, vPlaneWater.bgb - vCamPos));

		float fLastDist = 0.0;
		float fStepFactor = 0.5;
		float fTmpDist = max(max(vPlaneTerrainDists.g, vPlaneTerrainDists.r), max(vPlaneWaterDists.g, vPlaneWaterDists.r));
		if (bAboveBelow.r) { // above upper bounding plane, step there and then march from there
			fTmpDist = vPlaneTerrainDists.r;
			fTotalDist = vPlaneTerrainDists.g;
		} else if (bAboveBelow.g) { // below lower bounding plane, jump there and then march from there
			fTmpDist = vPlaneTerrainDists.g;
			fTotalDist = vPlaneTerrainDists.r;
		}
		// the marching -- note in desktop GLSL there is NO iteration limit, the loop is more like for (;;)  -- not allowed in GLSL ES it seems
		for (int i = 0; i < 200; i++) {
			vPos = vCamPos + (vDir * fTotalDist);
			fLastDist = DistTerrains(vPos);
			fTotalDist += fLastDist * fStepFactor;
			if (fTotalDist > fTmpDist) { break; }
			if (fLastDist < fNearLimit) {
				tMat.vNormal = NormalCentroidTerrains(vPos, fNearLimit * 0.1, fLastDist);
				return;
			}
			fStepFactor += (fTotalDist * uScreenX * 0.125);//clamp(1.0 / (fTotalDist * 0.1), 0.000000000, 1.000000005));
			fNearLimit = (fTotalDist * uScreenX);
		}
	}
	fTotalDist = fMaxDist;
}

vec3 Hsv2Rgb(vec3 hsv) {
	return mix(vec3(1.0), clamp((abs(fract(hsv.r + vec3(3.0, 2.0, 1.0) / 3.0) * 6.0 - 3.0) - 1.0), 0.0, 1.0), hsv.g) * hsv.b;
}

vec3 PhongLightSimple (const in vec3 vPos, const in vec3 vDir, const in float fEpsilon, const in float fTotalDist, const in vec3 vObjCol, const in vec3 vNormal, const in vec3 vLightDir, const in vec3 vLightCol) {
	vec3 vV = normalize(vCamPos - vPos);
	vec3 vH = normalize(vV + vLightDir);

	float fDiff = SATURATE(dot(vNormal, vLightDir));
	vec3 vCol = mix(vec3(0.0), vObjCol, fDiff);

	float fSpec = SATURATE(pow(SATURATE(dot(vec3(vNormal), vH)), 512.0));
	vCol += vLightCol * fSpec;
	return vCol;
}

void main( void ) {
	vec2 vPos = gl_FragCoord.xy / resolution.xy;
	vec2 vViewPlane = ((vPos * 2.0) - 1.0) / vec2(1.0, resolution.x / resolution.y);
	float n = surface3(vec3(vViewPlane, time * .02));	
	vec3 vForwards = normalize(vec3(0.0, sin(time * 1.0), 1.0) - vCamPos);
	vec3 vRight = normalize(cross(vForwards, vec3(0, 1, 0)));
	vec3 vUp = n+cross(vRight, vForwards);

	vec3 vRayDir = normalize((-vRight * vViewPlane.x) + (vUp * vViewPlane.y) + vForwards);
	vec3 vRayPos = vCamPos;


	const float fMaxDist = 300.0; // 300km if view-plane (unit width) is considered to be 0.1m wide...
	vec3 vFragColor;
	float fTotalDist = EPSILON;
	float fDelta = fTotalDist * 0.5;
	TMaterial tMat;
	RaymarchTerrains(vRayPos, vRayDir, fMaxDist, fDelta, fTotalDist, tMat);
	vec3 vObjCol = clamp(normalize(vRayPos.xzy), vec3(0.25), vec3(0.75));
	vec3 vLightDir = normalize(vec3(0.33, 0.33, 1.0)); // normalize(vec3(-cos(uTime * 0.25), 1, sin(uTime * 0.25))); // normalize(vCamPos - vRayPos);
	const vec3 vSunColor = vec3(1.0, 0.9, 0.7);
	vec3 vSkyColor;

	vSkyColor = mix(vec3(0.48, 0.5, 0.52), vec3(0.3, 0.9, 1.0), SATURATE(vRayDir.y * 8.0 + 0.2));
	vSkyColor = mix(vSkyColor, vec3(0.17, 0.36, 0.71), SATURATE(vRayDir.y * 2.0 + 0.85 /* 0.5*/));
	vSkyColor = mix(vSkyColor, vec3(0.0, 0.15, 0.51), SATURATE(vRayDir.y * 1.4));

	if (fTotalDist >= fMaxDist) {
		vFragColor = vSkyColor+(n*12.);
	} else {
		vFragColor = PhongLightSimple(vRayPos, vRayDir, fDelta, fTotalDist, Hsv2Rgb(vObjCol), tMat.vNormal, vLightDir, vSunColor);
	}
	// just gamma
	gl_FragColor = vec4(pow(vFragColor, vec3(1.0 / 2.2)), 1.0);
}
