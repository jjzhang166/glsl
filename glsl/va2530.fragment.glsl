/*

Set the quality to 4 or 8 for smoother running.

*/

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 vCamPos = vec3(0.0, 600.0 + (sin(time * 0.5) * 500.0), (time * 500.0));
float DistTerrains (const in vec3 vPos);

#define SATURATE(v) clamp(v, 0.0, 1.0)

#define EPSILON 0.00000012
#define PI 3.14159265358979323846264
#define PI2 PI * 2.0	

#define uScreenX (1.0 / resolution.x)
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

struct TMaterial {
	vec3 vNormal; // that's all for now...
};


float DistFloor (const in vec3 vPos) {
	float f1 = snoise(vPos.xz * 0.001) * ((2.0 + sin(vPos.x * 0.04)) + (2.0 + cos(vPos.x * 0.02))) * 16.0; // 10.0 * sin(vPos.z * 0.125) * cos(vPos.x * 0.125); // texture(uTex0, vPos.xz * 0.05).r; // 
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
	const vec3 vPlaneTerrain = vec3(-100.0 - 1.0, 100.0 + 1.0, 0.0); // bounding plane: above terrains' highest and below its lowest elevation
	const vec3 vPlaneWater = vec3(-9.0 - 0.1, 9.0 + 0.1, 0.0); // not used right now
	bvec2 bAboveBelow = bvec2(step(vPlaneTerrain.g, vCamPos.y), step(vCamPos.y, vPlaneTerrain.r));

	if (!((bAboveBelow.r && (vDir.y >= 0.0)) || (bAboveBelow.g && (vDir.y <= 0.0)))) { // only march if ray above terrain goes down or ray below terrain goes up
		// intersect with bounding planes
		const vec3 vPlaneNormal = vec3(0.0, 1.0, 0.0);
		float fInvDotNormal = 1.0 / dot(vPlaneNormal, vDir + EPSILON);
		vec2 vPlaneTerrainDists = fInvDotNormal * vec2(dot(vPlaneNormal, vPlaneTerrain.brb - vCamPos), dot(vPlaneNormal, vPlaneTerrain.bgb - vCamPos));
		vec2 vPlaneWaterDists = fInvDotNormal * vec2(dot(vPlaneNormal, vPlaneWater.brb - vCamPos), dot(vPlaneNormal, vPlaneWater.bgb - vCamPos));

		float fLastDist = 0.0;
		float fStepFactor = 0.1;
		float fTmpDist = max(max(vPlaneTerrainDists.g, vPlaneTerrainDists.r), max(vPlaneWaterDists.g, vPlaneWaterDists.r));
		if (bAboveBelow.r) { // above upper bounding plane, step there and then march from there
			fTmpDist = vPlaneTerrainDists.r;
			fTotalDist = vPlaneTerrainDists.g;
		} else if (bAboveBelow.g) { // below lower bounding plane, jump there and then march from there
			fTmpDist = vPlaneTerrainDists.g;
			fTotalDist = vPlaneTerrainDists.r;
		}
		// the marching -- note in desktop GLSL there is NO iteration limit, the loop is more like for (;;)  -- not allowed in GLSL ES it seems
		for (int i = 0; i < 480; i++) {
			vPos = vCamPos + (vDir * fTotalDist);
			fLastDist = DistTerrains(vPos);
			fTotalDist += fLastDist * fStepFactor;
			if (fTotalDist > fTmpDist) { break; }
			if (fLastDist < fNearLimit) {
				tMat.vNormal = NormalCentroidTerrains(vPos, fNearLimit * 1.0, fLastDist);
				return;
			}
			fStepFactor += (fTotalDist * uScreenX * 0.03);//clamp(1.0 / (fTotalDist * 0.1), 0.000000000, 1.000000005));
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


vec3 Fog (const in vec3 vFinalCol, const in vec3 vFogColor, const in vec3 vSunColor, const in float fTotalDist, const in vec3 vRayPos, const in vec3 vRayDir, const in vec3 vSunDir) {
	float fFogDensityAltitude = 1.0 / (vCamPos.y * 120.0); // 1 / (vCamPos.y * 12);
	const float fFogDensityDistance = 3.0;
	float fFogAmount = fFogDensityDistance * exp(-vRayPos.y * fFogDensityAltitude) * (1.0 - exp(-fTotalDist * vRayDir.y * fFogDensityAltitude)) / vRayDir.y; // exp(-fTotalDist * fFogDensity);
	float fSunAmount = max(dot(vRayDir, vSunDir), 0.0);
	vec3 vMixColor = mix(vFogColor, vSunColor, pow(fSunAmount, 12.0));
	// return mix(vFinalCol, vMixColor, SATURATE(fFogAmount));
	return vFinalCol * (1.0 - SATURATE(fFogAmount)) + vMixColor * SATURATE(fFogAmount);
}

vec3 Tonemap (const in vec3 vColor) {
	const float fShoulder = 0.33; // 0.22 // 0.15;
	const float fLinStrength = 0.2; // 0.30 // 0.50;
	const float fLinAngle = 0.1; // 0.10 // 0.10
	const float fToeStrength = 0.20; // 0.20 // 0.20
	const float fToeNumerator = 0.001; // 0.01 // 0.02;
	const float fToeDenominator = 0.20; // 0.30 // 0.33
	return ((vColor * ((fShoulder * vColor) + (fLinAngle * fLinStrength)) + (fToeStrength * fToeNumerator)) / (vColor * ((fShoulder * vColor) + fLinStrength) + (fToeStrength * fToeDenominator))) - (fToeNumerator / fToeDenominator);
}

void main( void ) {
	vec2 vPos = gl_FragCoord.xy / resolution.xy;
	vec2 vViewPlane = ((vPos * 2.0) - 1.0) / vec2(1.0, resolution.x / resolution.y);
	vec3 vForwards = -normalize(vec3(0.0, 0.0, 0.0) - vCamPos);
	vec3 vRight = normalize(cross(vForwards, vec3(0, 1, 0)));
	vec3 vUp = cross(vRight, vForwards);

	vec3 vRayDir = normalize((-vRight * vViewPlane.x) + (vUp * vViewPlane.y) + vForwards);
	vec3 vRayPos = vCamPos;

	const float fMaxDist = 3000000.0; // 300km if view-plane (unit width) is considered to be 0.1m wide...
	vec3 vFragColor;
	float fTotalDist = EPSILON;
	float fDelta = fTotalDist * 0.5;
	TMaterial tMat;
	RaymarchTerrains(vRayPos, vRayDir, fMaxDist, fDelta, fTotalDist, tMat);
	vec3 vObjCol = clamp((vRayPos.yzy * 0.012), vec3(0.175), vec3(0.66));
	vec3 vLightDir = normalize(vec3(0.75 + sin(time * 0.25) * 0.75, sin(time * 0.1), 0.75 + cos(time * 0.75))); // normalize(vec3(-cos(uTime * 0.25), 1, sin(uTime * 0.25))); // normalize(vCamPos - vRayPos);
	const vec3 vSunColor = vec3(1.5, 2.5, 10.0);
	vec3 vSkyColor;

	vSkyColor = mix(vec3(0.48, 0.5, 0.52), vec3(0.3, 0.9, 1.0), SATURATE(vRayDir.y * 8.0 + 0.2));
	vSkyColor = mix(vSkyColor, vec3(0.71, 0.36, 0.17), SATURATE(vRayDir.y * 2.0 + 0.85 /* 0.5*/));
	vSkyColor = mix(vSkyColor, vec3(0.51, 0.15, 0.0), SATURATE(vRayDir.y * 1.4));

	if (fTotalDist >= fMaxDist) {
		vFragColor = vSkyColor;
	} else {
		vFragColor = PhongLightSimple(vRayPos, vRayDir, fDelta, fTotalDist, Hsv2Rgb(vObjCol), tMat.vNormal, vLightDir, vSunColor);
	}
	vFragColor.rgb = Fog(vFragColor.rgb, vSkyColor, vSunColor, fTotalDist, vRayPos, vRayDir, vLightDir);
	if (fTotalDist >= fMaxDist) { vFragColor += snoise(vPos * (cos(time * 0.1) + sin(time * 0.1)) * 8.0) * 0.2; }
	vec3 vNumerator = Tonemap(vFragColor);
	vec3 vDenominator = Tonemap(vec3(11.2));
	vFragColor = vNumerator / vDenominator;
	gl_FragColor = vec4(pow(vFragColor, vec3(1.0 / 2.2)), 1.0);
}
