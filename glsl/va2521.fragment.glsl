/*

Set the quality to 4 or 8 for smoother running.

---
Removed abs() from distance function to enable signed distances (and avoid stepping through terrain).
Set step size to 0.9 for 9x faster marching...
Dropped iteration count to sensible number ;)
psonice
*/

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
	vec3 vForwards = normalize(vec3(0.0, sin(time * 1.0), 1.0) - vCamPos);
	vec3 vRight = normalize(cross(vForwards, vec3(0, 1, 0)));
	vec3 vUp = cross(vRight, vForwards);

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
		vFragColor = vSkyColor;
	} else {
		vFragColor = PhongLightSimple(vRayPos, vRayDir, fDelta, fTotalDist, Hsv2Rgb(vObjCol), tMat.vNormal, vLightDir, vSunColor);
	}
	// just gamma
	gl_FragColor = vec4(pow(vFragColor, vec3(1.0 / 2.2)), 1.0);
}
