/*

Set the quality to 8 rrrright NAOW! Before this kills your browser tab or GPU.

*/

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float fScale = 1.0 / min(resolution.x, resolution.y);
float fDetail = 1.0 / min(resolution.x, resolution.y);

vec3 vCamPos = vec3(sin(-time * 0.25) * 40.0, 1.0 + abs(cos(time * 0.5) * 28.0), cos(-time * 0.25) * 20.0);

float DistAll (const in vec3 vPos);

#define NORMAL NormalSimple
#define SATURATE(v) clamp(v, 0.0, 1.0)

#define EPSILON 0.000004 /* 0.00000011920928955078125; */
#define PI 3.14159265358979323846264
#define PI2 PI * 2.0

#define FADE(v) (v * v * v * (v * (v * 6.0 - 15.0) + 10.0))

#define MOD(n, v) (v - floor(v * (1.0 / n)) * n)

vec3 Lerp (const in vec3 v1, const in vec3 v2, const in float f) {
	return v1 + (v2 - v1) * f;
}

float Max3 (const in vec3 vVec) {
	return max(vVec.x, max(vVec.y, vVec.z));
}

mat4 MatrixIdentity () {
	return mat4(
		1, 0, 0, 0,
		0, 1, 0, 0,
		0, 0, 1, 0,
		0, 0, 0, 1
	);
}

mat4 MatrixTranslate (const in vec3 v){
	return mat4(
		1, 0, 0, 0,
		0, 1, 0, 0,
		0, 0, 1, 0,
		v.x, v.y, v.z, 1
	);
}

mat4 MatrixScale (const in vec3 v) {
	return mat4(
		v.x, 0, 0, 0,
		0, v.y, 0, 0,
		0, 0, v.z, 0,
		0, 0, 0, 1
	);
}

float Pow2 (const in float f) {
	return f * f;
}

float Pow3 (const in float f) {
	return f * f * f;
}

float Pow4 (const in float f) {
	return f * f * f * f;
}

float Pow5 (const in float f) {
	return f * f * f * f * f;
}

float Pow6 (const in float f) {
	return f * f * f * f * f * f;
}

float Pow7 (const in float f) {
	return f * f * f * f * f * f * f;
}

float Pow8 (const in float f) {
	return f * f * f * f * f * f * f * f;
}

float PowEvenN (const in float fVal, const in float fPow) {
	return pow(abs(fVal), fPow);
}

#define Length(v, n) pow(Pow##n(v.x) + Pow##n(v.y), 1.0 / ##n)

float Length8 (const in vec2 v) {
	return pow(Pow8(v.x) + Pow8(v.y), 1.0 / 8.0);
}

float Length8 (const in vec3 v) {
	return pow(Pow8(v.x) + Pow8(v.y) + Pow8(v.z), 1.0 / 8.0);
}

float LengthEvenN (const in vec2 v, const in float fN) {
	return pow(PowEvenN(v.x, fN) + PowEvenN(v.y, fN), 1.0 / fN);
}

float LengthEvenN (const in vec3 v, const in float fN) {
	return pow(PowEvenN(v.x, fN) + PowEvenN(v.y, fN) + PowEvenN(v.z, fN), 1.0 / fN);
}

float Rand (const in vec2 vSeed) {
	const vec2 vR1 = vec2(12.9898, 78.233);
	const float fR1 = 43758.5453;
	return fract(sin(dot(vSeed, vR1)) * fR1);
}

vec3 Rand3 (const in vec2 vSeed) {
	const vec2 vR1 = vec2(12.9898, 78.233);
	const vec2 vR2 = vec2(4.898, 7.23);
	const vec2 vR3 = vec2(0.23, 1.111);
	const float fR1 = 43758.5453;
	const float fR2 = 23421.631;
	const float fR3 = 392820.23;
	return vec3(fract(sin(dot(vSeed, vR1)) * fR1), fract(sin(dot(vSeed, vR2)) * fR2), fract(sin(dot(vSeed, vR3)) * fR3));
}

float SmoothCurve (float f) {
	return 0.5 * (1.0 + cos(PI * f));
}

vec4 TaylorInvSqrt (vec4 v) {
	return 1.79284291400159 - 0.85373472095314 * v;
}

vec3 Hsv2Rgb(vec3 hsv) {
	return mix(vec3(1.0), clamp((abs(fract(hsv.r + vec3(3.0, 2.0, 1.0) / 3.0) * 6.0 - 3.0) - 1.0), 0.0, 1.0), hsv.g) * hsv.b;
}

float AmbientOcclusion (const in vec3 vPos, const in vec3 vNormal, const in float fEpsilon) {
	// const float fEpsilon = 0.01;
	float fTotal = 0.0;
	float fWeight = 0.5;
	float fDelta;

	for (float i = 0.0; i < 5.0; ++i) {
		fDelta = (i + 1.0) * (i + 1.0) * 0.01 * 12.0;
		fTotal += fWeight * (fDelta - DistAll(vPos + (vNormal * fDelta)));
		fWeight *= 0.5;
	}

	return 1.0 - SATURATE(fTotal);
}

float FresnelSchlick (const in float f0, const in vec3 vNormal, const in vec3 vLight) {
	return f0 + (1.0 - f0) * pow(1.0 - dot(vNormal, vLight), 5.0);
}

float Shadow (const in vec3 vPos, const in vec3 vDir, const in float fMin, const in float fMax) {
	float fDist;
	float fShadow = 1.0;
	// float chk = 0;
	float fStep = fMin;
	for (int i = 0; i < 32; i++) {
		fDist = DistAll(vPos + (vDir * fStep));
		if ((fShadow == 0.0) || (fMax < fStep) || (fMax < fDist)) {
			break;
		}
		fShadow = min(fShadow, 16.0 * step(0.001, fDist) * fDist / fStep);
		fStep += fDist;
	}
	return fShadow;
}

float SubsurfaceScattering (const in vec3 vPos, const in vec3 vDir) {
	const float fEpsilon = 0.01;
	float fTotal = 0.0;
	float fWeight = 0.2;
	float fDelta;

	for (float i = 0.0; i < 5.0; ++i) {
		fDelta = pow(i + 1.0, 2.5) * fEpsilon * 12.0;
		fTotal += -fWeight * min(0.0, DistAll(vPos + vDir * fDelta));
		fWeight *= 0.2;
	}

	return SATURATE(fTotal);
}

vec3 PhongLightSimple (const in vec3 vPos, const in vec3 vDir, const in float fEpsilon, const in float fTotalDist, const in vec3 vObjCol, const in vec3 vNormal, const in vec3 vLightDir, const in vec3 vLightCol) {
	const vec3 vSunColor = vec3(1.0, 0.9, 0.7);
	vec3 vV = normalize(vCamPos - vPos);
	vec3 vH = normalize(vV + vLightDir);

	float fDiff = SATURATE(dot(vNormal, vLightDir));
	vec3 vCol = mix(vec3(0.0), vObjCol, fDiff);

	float fAO = AmbientOcclusion(vPos, vNormal, fEpsilon);
	vCol = mix(vec3(0.0), vCol, fAO);

	float fSSS = SubsurfaceScattering(vPos, vDir);
	vCol = mix(vCol, vec3(0.4, 0.2, 0.0), fSSS);

	float fSpec = SATURATE(pow(SATURATE(dot(vNormal, vH)), 512.0));
	vCol += vSunColor * fSpec;
	return vCol;
}

float OpBlend (const in float fD1, const in float fD2) {
	return mix(fD1, fD2, SmoothCurve(fD1 - fD2));
}

float OpIntersect (const in float fD1, const in float fD2) {
	return max(fD1, fD2);
}

vec3 OpRepeat (const in vec3 vPos, const in vec3 vRepeat) {
	return mod(vPos, vRepeat) - (vRepeat * 0.5);
}

vec3 OpRotateY (const in vec3 vPos, const in float fAngle) {
	vec2 vSinCos = vec2(sin(fAngle), cos(fAngle));
	return vec3(vPos.x * vSinCos[1] + vPos.z * vSinCos[0], vPos.y, vPos.z * vSinCos[1] - vPos.x * vSinCos[0]);
}

float OpSubtract (const in float fD1, const in float fD2) {
	return max(-fD1, fD2);
}

float OpUnion (const in float fD1, const in float fD2) {
	return min(fD1, fD2);
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
	return max(vQ.z - vHexPrism.y, max(vQ.x + vQ.y * 0.6, vQ.y) - vHexPrism.x);
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

#define DistTorusNNX(vPos, vTorus, n1, n2) Length(vec2(Length(vPos.yz, ##n1) - vTorus.x, vPos.x), ##n2) - vTorus.y

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

vec3 NormalSimple (const in vec3 vPos, const in float fDist) {
	vec2 vDelta = vec2(max(0.0004, fDist), 0);
	return normalize(vec3(
		DistAll(vPos + vDelta.xyy) - DistAll(vPos - vDelta.xyy),
		DistAll(vPos + vDelta.yxy) - DistAll(vPos - vDelta.yxy),
		DistAll(vPos + vDelta.yyx) - DistAll(vPos - vDelta.yyx)
	));
}
float DistTerrain (const in vec3 vPos) {
	return vPos.y - 0.5 + SmoothCurve(vPos.x) * SmoothCurve(vPos.z); // + (sin(vPos.x)) * (cos(vPos.z));
}

float DistWater (const in vec3 vPos) {
	return vPos.y;
}

float DistAll (const in vec3 vPos) {
	float thingy = OpSubtract(DistSphere(vPos, vec3(-3.0, 2.0, 0.0), 6.0), DistBox(vPos, vec3(2.0, 8.0, 6.0), 0.5));
	thingy = OpUnion(thingy, DistBox(OpRepeat(OpRotateY(vPos, SmoothCurve(time) * PI), vec3(24.0, 44.0 + cos(time * 8.0) * 8.0, 12.0 + sin(time) * 4.0)), vec3(1.25), max(0.0, sin(time * 0.5))));

	thingy = OpUnion(thingy, DistSphere(vPos, vec3(-2.0, 8.5, 6.0), 2.0));
	thingy = OpUnion(thingy, DistCylinderZ(vPos, vec2(0.0, 3.0), 0.5));
	thingy = OpUnion(thingy, DistTorusNX(OpRotateY(vPos, cos(time * 0.5)), vec3(0.0, 0.5, 0.0), vec2(21.0, 2.0), vec2(8.0, 2.0)));
	thingy = OpUnion(thingy, DistTorusY(vPos, vec3(0.0, -1.0, 0.0), vec2(22.0, 3.0)));
	thingy = OpUnion(thingy, DistTorusNZ(OpRotateY(vPos, sin(time * 2.0)), vec2(20.0, 1.0), vec2(2.0, 8.0)));
	thingy = OpUnion(thingy, DistConeY(vPos, vec3(-22.0, 6.0, 0.0), normalize(vec2(5.0, -3.0))));
	thingy = OpUnion(thingy, DistHexPrism(vPos, vec3(-22.0, 3.0, -8.0), vec2(2.0, 2.0)));

	thingy = OpUnion(thingy, OpSubtract(DistBox(OpRotateY(vPos, sin(time * 0.5)), vec3(30.0, 5.5 - cos(time * 4.0) * 8.0, 12.0), vec3(3.0, 6.0, 3.0)), DistBox(OpRotateY(vPos, sin(time * 0.5)), vec3(30.0, 7.5 - cos(time * 4.0) * 12.0, 10.0), vec3(4.0, 8.0, 4.0))));
	float terrainWater = OpUnion(DistWater(vPos), DistTerrain(vPos));
	return OpUnion(thingy, terrainWater);
	// return OpUnion(DistTerrain(vPos), OpUnion(DistBox(/*DomainRepeat(vPos, vec3(12, 6, 18))*/ vPos - vec3(2, 3, 0), vec3(1), 0.125), DistSphere(vPos - vec3(sin(uTime * 2), 2, cos(uTime * 2) + 12), 1)));
	// return ObjUnion(obj0(p), obj1(p));
}

void Raymarch (inout vec3 vPos, const in vec3 vDir, inout float fNearLimit, const in float fMaxDist, out float fTotalDist, out float fLastDist) {
	float fFactor = fScale * fDetail; // 674545
	fLastDist = fNearLimit;
	fTotalDist = fLastDist;
	for (int i = 0; i < 188; i++) {
		if (!bool(step(fNearLimit, fLastDist) * step(fTotalDist, fMaxDist))) break;
		fTotalDist += fLastDist;
		vPos = vCamPos + (vDir * fTotalDist);
		fLastDist = DistAll(vPos);
		fNearLimit = fTotalDist * fFactor;
		// fMaxDist = (abs(max(vCamPos.y, vPos.y)) * 30);
	}
}

void main( void ) {
	vec2 vPos = gl_FragCoord.xy / resolution.xy;
	vec2 vViewPlane = ((vPos * 2.0) - 1.0) / vec2(1.0, resolution.x / resolution.y);
	vec3 vForwards = normalize(vec3(0.0, sin(time) * 40.0, 0.0) - vCamPos);
	vec3 vRight = normalize(cross(vForwards, vec3(0, 1, 0)));
	vec3 vUp = cross(vRight, vForwards);

	vec3 vRayDir = normalize((-vRight * vViewPlane.x) + (vUp * vViewPlane.y) + vForwards);
	vec3 vRayPos = vCamPos;

	const float fMaxDist = 130.0;
	const vec3 vLightCol = vec3(1.0);
	vec3 vFragColor;
	float fLastDist, fTotalDist;
	float fEpsilon = EPSILON;
	Raymarch(vRayPos, vRayDir, fEpsilon, fMaxDist, fTotalDist, fLastDist);
	vec3 vObjCol = clamp(normalize(vRayPos.xzy) * sin(time * 2.0), vec3(0.25), vec3(0.75)); // vec3(0.33); // 
	// fTotalDist = Raymarch2(vRayPos, normalize(vRayDir), fLastDist);
	vec3 vLightDir = normalize(vec3(-0.33, 0.66, 1)); // normalize(vCamPos - vRayPos);

	vec3 vSkyColor = mix(vec3(0.48, 0.5, 0.52), vec3(0.3, 0.9, 1.0), SATURATE(vRayDir.y * 8.0 + 0.2));
	vSkyColor = mix(vSkyColor, vec3(0.17, 0.36, 0.71), SATURATE(vRayDir.y * 2.0 + 0.85 /* 0.5*/));
	vSkyColor = mix(vSkyColor, vec3(0.0, 0.15, 0.51), SATURATE(vRayDir.y * 1.4));

	if (fTotalDist >= fMaxDist) {
		// vFragColor = vec3(0.5, 0.6, 0.7);
		vFragColor = vSkyColor;
	} else {
		vec3 vNormal = NORMAL(vRayPos, fEpsilon);
		vFragColor = PhongLightSimple(vRayPos, vRayDir, fEpsilon, fTotalDist, Hsv2Rgb(vObjCol), vNormal, vLightDir, vLightCol);
		const float fFogMinDist = 60.0;
		vFragColor = mix(vFragColor, vSkyColor, max(0.0, (fTotalDist - fFogMinDist) / (fMaxDist - fFogMinDist)));
	}
	gl_FragColor = vec4(pow(vFragColor, vec3(1.0 / 2.2)), 1.0);
}
