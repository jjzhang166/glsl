/*

Mouse-move up/down: look up/down
Mouse-move left/right: move backwards/forwards (cam always points to center of scene)
Set resolution from 2 (default) to 4 or 8 for faster speeds. 1 or 0.5 will kill your GPU.
Now click "hide code"  :)

*/

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float DistAll (const in vec3 vPos);

#define EPSILON 0.0000001 /* 1920928955078125; */
#define PI 3.1415926535
#define PI2 PI * 2.0

#define NORMAL NormalSimple
#define SATURATE(v) clamp(v, 0.0, 1.0)

float Max3 (const in vec3 vVec) {
	return max(vVec.x, max(vVec.y, vVec.z));
}

float PowEvenN (const in float fVal, const in float fPow) {
	return pow(abs(fVal), fPow);
}

float LengthEvenN (const in vec2 v, const in float fN) {
	return pow(PowEvenN(v.x, fN) + PowEvenN(v.y, fN), 1.0 / fN);
}

float LengthEvenN (const in vec3 v, const in float fN) {
	return pow(PowEvenN(v.x, fN) + PowEvenN(v.y, fN) + PowEvenN(v.z, fN), 1.0 / fN);
}

vec3 Hsv2Rgb(vec3 hsv) {
	return mix(vec3(1.0), clamp((abs(fract(hsv.r + vec3(3.0, 2.0, 1.0) / 3.0) * 6.0 - 3.0) - 1.0), 0.0, 1.0), hsv.g) * hsv.b;
}

float AmbientOcclusion (const in vec3 vPos, const in vec3 vNormal) {
	const float fEpsilon = 0.01;
	float fTotal = 0.0;
	float fWeight = 0.5;
	float fDelta;

	for (float i = 0.0; i < 5.0; ++i) {
		fDelta = (i + 1.0) * (i + 1.0) * fEpsilon * 12.0;
		fTotal += fWeight * (fDelta - DistAll(vPos + vNormal * fDelta));
		fWeight *= 0.5;
	}

	return 1.0 - SATURATE(fTotal);
}

float SubsurfaceScattering (const in vec3 vPos, const in vec3 vDir) {
	const float fEpsilon = 0.01;
	float fTotal = 0.0;
	float fWeight = 0.4;
	float fDelta;

	for (float i = 0.0; i < 5.0; ++i) {
		fDelta = pow(i + 1.0, 2.5) * fEpsilon * 12.0;
		fTotal += -fWeight * min(0.0, DistAll(vPos + vDir * fDelta));
		fWeight *= 0.4;
	}

	return SATURATE(fTotal);
}

vec3 OpRepeat (const in vec3 vPos, const in vec3 vRepeat) {
	return mod(vPos, vRepeat) - (vRepeat * 0.5);
}

float DistOpSubtract (const in float d1, const in float d2) {
	return max(-d1, d2);
}

float DistOpUnion (const in float d1, const in float d2) {
	return min(d1, d2);
}

vec3 OpRotateY (const in vec3 vPos, const in float fAngle) {
	vec2 vSinCos = vec2(sin(fAngle), cos(fAngle));
	return vec3(vPos.x * vSinCos[1] + vPos.z * vSinCos[0], vPos.y, vPos.z * vSinCos[1] - vPos.x * vSinCos[0]);
}

float DistBox (const in vec3 vPos, const in vec3 vBoxSize) {
	return length(max(abs(vPos) - vBoxSize, 0.0));
}

float DistBox (const in vec3 vPos, const in vec3 vCenter, const in vec3 vBoxSize) {
	return Max3(abs(vCenter - vPos) - vBoxSize);
}

float DistBox (const in vec3 vPos, const in vec3 vBoxSize, const in float fRadius) {
	return length(max(abs(vPos) - vBoxSize, 0.0)) - fRadius;
}

float DistConeY (const in vec3 vPos, const in vec2 vCone) {
	float vQ = length(vPos.xz);
	return dot(vCone, vec2(vQ, vPos.y));
}

float DistConeY (const in vec3 vPos, const in vec3 vCenter, const in vec2 vCone) {
	return DistConeY(vCenter - vPos, vCone);
}

float DistCylinderX (const in vec3 vPos, const in vec2 vCenter, const in float fRadius) {
	return length(vCenter - vPos.yz) - fRadius;
}

float DistCylinderX (const in vec3 vPos, const in vec3 vCenter, const in float fRadius, const in float fWidth) {
	return max(length(vCenter.yz - vPos.yz) - fRadius, abs(vCenter.x - vPos.x) - fWidth * 0.5);
}

float DistCylinderY (const in vec3 vPos, const in vec2 vCenter, const in float fRadius) {
	return length(vCenter - vPos.xz) - fRadius;
}

float DistCylinderY (const in vec3 vPos, const in vec3 vCenter, const in float fRadius, const in float fHeight) {
	return max(length(vCenter.xz - vPos.xz) - fRadius, abs(vCenter.y - vPos.y) - fHeight * 0.5);
}

float DistCylinderZ (const in vec3 vPos, const in vec2 vCenter, const in float fRadius) {
	return length(vCenter - vPos.xy) - fRadius;
}

float DistCylinderZ (const in vec3 vPos, const in vec3 vCenter, const in float fRadius, const in float fDepth) {
	return max(length(vCenter.xy - vPos.xy) - fRadius, abs(vCenter.z - vPos.z) - fDepth * 0.5);
}

float DistHexPrism (const in vec3 vPos, const in vec2 vHexPrism) {
	vec3 vQ = abs(vPos);
	return max(vQ.z - vHexPrism.y, max(vQ.x + vQ.y * 0.57735, vQ.y) - vHexPrism.x);
}

float DistHexPrism (const in vec3 vPos, const in vec3 vCenter, const in vec2 vHexPrism) {
	return DistHexPrism(vCenter - vPos, vHexPrism);
}

float DistSphere (const in vec3 vPos, const in float fRadius) {
	return length(vPos) - fRadius;
}

float DistSphere (const in vec3 vPos, const in vec3 vCenter, const in float fRadius) {
	return length(vCenter - vPos) - fRadius;
}

float DistTorusNX (const in vec3 vPos, const in vec2 vTorus, const in vec2 vN) {
	vec2 vQ = vec2(LengthEvenN(vPos.yz, vN[0]) - vTorus.x, vPos.x);
	return LengthEvenN(vQ, vN[1]) - vTorus.y;
}

float DistTorusNX (const in vec3 vPos, const in vec3 vCenter, const in vec2 vTorus, const in vec2 vN) {
	return DistTorusNX(vCenter - vPos, vTorus, vN);
}

float DistTorusNY (const in vec3 vPos, const in vec2 vTorus, const in vec2 vN) {
	vec2 vQ = vec2(LengthEvenN(vPos.xz, vN[0]) - vTorus.x, vPos.y);
	return LengthEvenN(vec2(vQ), vN[1]) - vTorus.y;
}

float DistTorusNY (const in vec3 vPos, const in vec3 vCenter, const in vec2 vTorus, const in vec2 vN) {
	return DistTorusNY(vCenter - vPos, vTorus, vN);
}

float DistTorusNZ (const in vec3 vPos, const in vec2 vTorus, const in vec2 vN) {
	vec2 vQ = vec2(LengthEvenN(vPos.xy, vN[0]) - vTorus.x, vPos.z);
	return LengthEvenN(vQ, vN[1]) - vTorus.y;
}

float DistTorusNZ (const in vec3 vPos, const in vec3 vCenter, const in vec2 vTorus, const in vec2 vN) {
	return DistTorusNZ(vCenter - vPos, vTorus, vN);
}

float DistTorusX (const in vec3 vPos, const in vec2 vTorus) {
	vec2 vQ = vec2(length(vPos.yz) - vTorus.x, vPos.x);
	return length(vQ) - vTorus.y;
}

float DistTorusX (const in vec3 vPos, const in vec3 vCenter, const in vec2 vTorus) {
	return DistTorusX(vCenter - vPos, vTorus);
}

float DistTorusY (const in vec3 vPos, const in vec2 vTorus) {
	vec2 vQ = vec2(length(vPos.xz) - vTorus.x, vPos.y);
	return length(vQ) - vTorus.y;
}

float DistTorusY (const in vec3 vPos, const in vec3 vCenter, const in vec2 vTorus) {
	return DistTorusY(vCenter - vPos, vTorus);
}

float DistTorusZ (const in vec3 vPos, const in vec2 vTorus) {
	vec2 vQ = vec2(length(vPos.xy) - vTorus.x, vPos.z);
	return length(vQ) - vTorus.y;
}

float DistTorusZ (const in vec3 vPos, const in vec3 vCenter, const in vec2 vTorus) {
	return DistTorusZ(vCenter - vPos, vTorus);
}

vec3 NormalMinimal (const in vec3 vPos, const in float fDist) {
	const vec3 vDelta = vec3(0.0001, 0.0, 0.0); // vec3(clamp(abs(fDist), 0.001, 1.) * 0.1, 0, 0);
	return normalize(vec3(fDist - DistAll(vPos - vDelta.xyy), fDist - DistAll(vPos - vDelta.yxy), fDist - DistAll(vPos - vDelta.yyx)));
}

vec3 NormalSimple (const in vec3 vPos, const in float fDist) {
	const vec2 vDelta = vec2(0.0001, 0);
	return normalize(vec3(
		DistAll(vPos + vDelta.xyy) - DistAll(vPos - vDelta.xyy),
		DistAll(vPos + vDelta.yxy) - DistAll(vPos - vDelta.yxy),
		DistAll(vPos + vDelta.yyx) - DistAll(vPos - vDelta.yyx)
	));
}

vec3 NormalTetra (const in vec3 vPos, const in float fDist) {
	const float fDelta = 0.00001;
	const vec3 vOffset1 = vec3( fDelta, -fDelta, -fDelta);
	const vec3 vOffset2 = vec3(-fDelta, -fDelta,  fDelta);
	const vec3 vOffset3 = vec3(-fDelta,  fDelta, -fDelta);
	const vec3 vOffset4 = vec3( fDelta,  fDelta,  fDelta);
	float f1 = DistAll(vPos + vOffset1);
	float f2 = DistAll(vPos + vOffset2);
	float f3 = DistAll(vPos + vOffset3);
	float f4 = DistAll(vPos + vOffset4);
	return normalize((vOffset1 * f1) + (vOffset2 * f2) + (vOffset3 * f3) + (vOffset4 * f4));
}

float DistTerrain (const in vec3 vPos) {
	return (vPos.y) - 0.3 + sin(vPos.x) * sin(vPos.z);
}

float DistWater (const in vec3 vPos) {
	return vPos.y;
}

float DistAll (const in vec3 vPos) {
	float thingy = DistOpSubtract(DistSphere(vPos, vec3(-3.0, 2.0, 0.0), 6.0), DistBox(vPos, vec3(2.0, 8.0, 6.0), 0.5));
	thingy = DistOpUnion(thingy, DistBox(OpRepeat(OpRotateY(vPos, time * PI2), vec3(24, 48, 16)), vec3(1.25)));
	thingy = DistOpUnion(thingy, DistSphere(vPos, vec3(-2.0, 8.5, 6.0), 2.0));
	thingy = DistOpUnion(thingy, DistCylinderZ(vPos, vec2(0.0, 3.0), 0.5));
	thingy = DistOpUnion(thingy, DistTorusNX(OpRotateY(vPos, cos(time * 0.5)), vec3(0.0, 0.5, 0.0), vec2(21.0, 2.0), vec2(8.0, 2.0)));
	thingy = DistOpUnion(thingy, DistTorusY(vPos, vec3(0.0, -1.0, 0.0), vec2(22.0, 3.0)));
	thingy = DistOpUnion(thingy, DistTorusNZ(OpRotateY(vPos, sin(time * 2.0)), vec2(20.0, 1.0), vec2(2.0, 8.0)));
	thingy = DistOpUnion(thingy, DistConeY(vPos, vec3(-22.0, 6.0, 0.0), normalize(vec2(5.0, -3.0))));
	thingy = DistOpUnion(thingy, DistHexPrism(vPos, vec3(-22.0, 3.0, -8.0), vec2(2.0, 2.0)));
	float terrainWater = DistOpUnion(DistWater(vPos), DistTerrain(vPos));
	return DistOpUnion(thingy, terrainWater);
}

void Raymarch (const in vec3 vCamPos, inout vec3 vRayPos, const in vec3 vRayDir, const in float fMaxDist, out float fTotalDist, out float fLastDist) {
	const float fNearLimit = 0.01;
	fLastDist = fNearLimit;
	fTotalDist = fLastDist;
	for (int i = 0; i < 9999; i++) {
		if (!bool(step(fNearLimit, fLastDist) * step(fTotalDist, fMaxDist))) break;
		fTotalDist += fLastDist;
		vRayPos = vCamPos + (vRayDir * fTotalDist);
		fLastDist = DistAll(vRayPos);
		// fMaxDist = (abs(max(uCamPos.y, vRayPos.y)) * 30);
	}
}

vec3 Light (const in vec3 vCamPos, const in vec3 vRayPos, const in vec3 vRayDir, const in float fTotalDist, const in vec3 vObjCol, const in vec3 vNormal, const in vec3 vLightDir, const in vec3 vLightCol) {
	vec3 vV = normalize(vCamPos - vRayPos);
	vec3 vH = normalize(vV + vLightDir);

	float fDiff = SATURATE(dot(vNormal, vLightDir));
	vec3 vCol = mix(vec3(0.0), vObjCol, fDiff);

	float fAO = AmbientOcclusion(vRayPos, vNormal);
	vCol = mix(vec3(0.0), vCol, fAO);

	float fSSS = SubsurfaceScattering(vRayPos, vRayDir);
	vCol = mix(vCol, vec3(0.4, 0.2, 0.0), fSSS);

	float fSpec = SATURATE(pow(SATURATE(dot(vNormal, vH)), 512.0));
	vCol += vec3(1.0, 0.9, 0.7) * fSpec;

	return vCol;
}

const vec3 vSkyColor = vec3(0.5, 0.6, 0.7);

void main( void ) {
	vec2 vPos = gl_FragCoord.xy / resolution.xy;
	vec3 vCamPos = vec3((mouse.x - 0.5) * resolution.x * 0.2, 9.0, 1);
	vec2 vViewPlane = ((vPos * 2.0) - 1.0) / vec2(1.0, resolution.x / resolution.y);
	vec3 vForwards = normalize(vec3(0.0, (mouse.y - 0.5) * resolution.y * 0.2, 1.0) - vCamPos);
	vec3 vRight = normalize(cross(vForwards, vec3(0, 1, 0)));
	vec3 vUp = cross(vRight, vForwards);
	vec3 vRayDir = normalize((-vRight * vViewPlane.x) + (vUp * vViewPlane.y) + vForwards);
	vec3 vRayPos = vCamPos;
	const vec3 vLightCol = vec3(1.0);
	const float fMaxDist = 115.0;
	float fLastDist, fTotalDist;
	Raymarch(vCamPos, vRayPos, vRayDir, fMaxDist, fTotalDist, fLastDist);
	vec3 vObjCol = clamp(normalize(vRayPos), vec3(0.25), vec3(0.95)); // vec3(0.33); // 
	vec3 vLightDir = normalize(vCamPos - vRayPos);
	vec3 vFragCol;
	if (fTotalDist >= fMaxDist) {
		vFragCol = vSkyColor; //background color
	} else {
		vec3 vNormal = NORMAL(vRayPos, fLastDist);
		vFragCol = Light(vCamPos, vRayPos, vRayDir, fTotalDist, Hsv2Rgb(vObjCol), vNormal, vLightDir, vLightCol);
	}
	gl_FragColor = vec4(pow(vFragCol, vec3(1.0 / 2.2)), 1);
}
