// interleaved version of http://glsl.heroku.com/e#5086.1 and
// http://glsl.heroku.com/e#5091.17
// compiled using glslify

// original source: https://gist.github.com/4186707

precision highp float;
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
#ifdef GL_ES

#endif

vec4 a_x_mod289(vec4 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}
vec3 a_x_mod289(vec3 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}
vec2 a_x_mod289(vec2 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}
float a_x_mod289(float x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}
vec4 a_x_permute(vec4 x) {
  return a_x_mod289(((x * 34.0) + 1.0) * x);
}
vec3 a_x_permute(vec3 x) {
  return a_x_mod289(((x * 34.0) + 1.0) * x);
}
float a_x_permute(float x) {
  return a_x_mod289(((x * 34.0) + 1.0) * x);
}
vec4 a_x_taylorInvSqrt(vec4 r) {
  return 1.79284291400159 - 0.85373472095314 * r;
}
float a_x_taylorInvSqrt(float r) {
  return 1.79284291400159 - 0.85373472095314 * r;
}
vec4 a_x_grad4(float j, vec4 ip) {
  const vec4 ones = vec4(1.0, 1.0, 1.0, -1.0);
  vec4 p, s;
  p.xyz = floor(fract(vec3(j) * ip.xyz) * 7.0) * ip.z - 1.0;
  p.w = 1.5 - dot(abs(p.xyz), ones.xyz);
  s = vec4(lessThan(p, vec4(0.0)));
  p.xyz = p.xyz + (s.xyz * 2.0 - 1.0) * s.www;
  return p;
}
float a_x_snoise(vec2 v) {
  const vec4 C = vec4(0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439);
  vec2 i = floor(v + dot(v, C.yy));
  vec2 x0 = v - i + dot(i, C.xx);
  vec2 i1;
  i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
  vec4 x12 = x0.xyxy + C.xxzz;
  x12.xy -= i1;
  i = a_x_mod289(i);
  vec3 p = a_x_permute(a_x_permute(i.y + vec3(0.0, i1.y, 1.0)) + i.x + vec3(0.0, i1.x, 1.0));
  vec3 m = max(0.5 - vec3(dot(x0, x0), dot(x12.xy, x12.xy), dot(x12.zw, x12.zw)), 0.0);
  m = m * m;
  m = m * m;
  vec3 x = 2.0 * fract(p * C.www) - 1.0;
  vec3 h = abs(x) - 0.5;
  vec3 ox = floor(x + 0.5);
  vec3 a0 = x - ox;
  m *= 1.79284291400159 - 0.85373472095314 * (a0 * a0 + h * h);
  vec3 g;
  g.x = a0.x * x0.x + h.x * x0.y;
  g.yz = a0.yz * x12.xz + h.yz * x12.yw;
  return 130.0 * dot(m, g);
}
float a_x_snoise(vec3 v) {
  const vec2 C = vec2(1.0 / 6.0, 1.0 / 3.0);
  const vec4 D = vec4(0.0, 0.5, 1.0, 2.0);
  vec3 i = floor(v + dot(v, C.yyy));
  vec3 x0 = v - i + dot(i, C.xxx);
  vec3 g = step(x0.yzx, x0.xyz);
  vec3 l = 1.0 - g;
  vec3 i1 = min(g.xyz, l.zxy);
  vec3 i2 = max(g.xyz, l.zxy);
  vec3 x1 = x0 - i1 + C.xxx;
  vec3 x2 = x0 - i2 + C.yyy;
  vec3 x3 = x0 - D.yyy;
  i = a_x_mod289(i);
  vec4 p = a_x_permute(a_x_permute(a_x_permute(i.z + vec4(0.0, i1.z, i2.z, 1.0)) + i.y + vec4(0.0, i1.y, i2.y, 1.0)) + i.x + vec4(0.0, i1.x, i2.x, 1.0));
  float n_ = 0.142857142857;
  vec3 ns = n_ * D.wyz - D.xzx;
  vec4 j = p - 49.0 * floor(p * ns.z * ns.z);
  vec4 x_ = floor(j * ns.z);
  vec4 y_ = floor(j - 7.0 * x_);
  vec4 x = x_ * ns.x + ns.yyyy;
  vec4 y = y_ * ns.x + ns.yyyy;
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
  vec4 norm = a_x_taylorInvSqrt(vec4(dot(p0, p0), dot(p1, p1), dot(p2, p2), dot(p3, p3)));
  p0 *= norm.x;
  p1 *= norm.y;
  p2 *= norm.z;
  p3 *= norm.w;
  vec4 m = max(0.6 - vec4(dot(x0, x0), dot(x1, x1), dot(x2, x2), dot(x3, x3)), 0.0);
  m = m * m;
  return 42.0 * dot(m * m, vec4(dot(p0, x0), dot(p1, x1), dot(p2, x2), dot(p3, x3)));
}
struct a_x_C_Ray {
  vec3 vOrigin;
  vec3 vDir;
};
struct a_x_C_HitInfo {
  float fDistance;
  float fObjectId;
  vec3 vPos;
};
struct a_x_C_Material {
  vec3 cAlbedo;
  float fR0;
  float fSmoothness;
};
vec2 a_x_DistCombineUnion(const in vec2 v1, const in vec2 v2) {
  return mix(v1, v2, step(v2.x, v1.x));
}
vec2 a_x_DistCombineUnionSphere(const in vec2 v1, const in vec2 v2) {
  if(abs(v1.x - v2.x) < 0.3)
    return mix(v1, v2, 0.5 * step(v2.x, v1.x));
  else
    return mix(v1, v2, step(v2.x, v1.x));
  
}
vec2 a_x_DistCombineIntersect(const in vec2 v1, const in vec2 v2) {
  return mix(v2, v1, step(v2.x, v1.x));
}
vec2 a_x_DistCombineSubtract(const in vec2 v1, const in vec2 v2) {
  return a_x_DistCombineIntersect(v1, vec2(-v2.x, v2.y));
}
float a_x_GetDistanceSphere(const in vec3 vPos, const in vec3 vSphereOrigin, const in float fSphereRadius) {
  return length(vPos - vSphereOrigin) - fSphereRadius;
}
float a_x_GetDistancePlane(const in vec3 vPos, const in vec3 vPlaneNormal, const in float fPlaneDist) {
  return dot(vPos, vPlaneNormal) + fPlaneDist;
}
float a_x_GetBumpyFloorHeight(const in vec3 vPos) {
  vec2 temp = vec2(((sin((vPos.x + time) * 2.0) + sin(vPos.z + time * 5.0)) * 0.1 + 0.1));
  return 0.2 * a_x_snoise(temp);
}
float a_x_GetDistanceBumpyFloor(const in vec3 vPos, const in float fHeight) {
  return vPos.y - fHeight + a_x_GetBumpyFloorHeight(vPos);
}
float a_x_sdSphere(vec3 p, float s) {
  return length(p) - s;
}
vec2 a_x_GetDistanceScene(const in vec3 vPos) {
  vec2 vDistPlane1 = vec2(a_x_GetDistanceBumpyFloor(vPos, -1.0), 1.0);
  vec3 vSphere1Pos = vec3(1.0 + sin(time), -0.3, cos(time));
  vSphere1Pos.y -= a_x_GetBumpyFloorHeight(vSphere1Pos);
  vec2 vDistSphere1 = vec2(a_x_GetDistanceSphere(vPos, vSphere1Pos, 0.75), 2.0);
  vec3 vSphere2Pos = vec3(-1.0 - sin(time), -0.3, cos(time));
  vSphere2Pos.y -= a_x_GetBumpyFloorHeight(vSphere2Pos);
  vec2 vDistSphere2 = vec2(a_x_GetDistanceSphere(vPos, vSphere2Pos, 0.75), 3.0);
  vec2 vResult = a_x_DistCombineUnionSphere(vDistSphere1, vDistSphere2);
  vResult = a_x_DistCombineUnion(vDistPlane1, vResult);
  return vResult;
}
a_x_C_Material a_x_GetObjectMaterial(in float fObjId, in vec3 vPos) {
  a_x_C_Material mat;
  mat.fR0 = 0.1;
  mat.fSmoothness = 0.5;
  if(fObjId < 1.5) {
    vec2 rg = vec2(1.0);
    vec2 vTile = step(fract(vec2(vPos.x + time, vPos.z)), vec2(0.5));
    float fBlend = mod(vTile.x + vTile.y, 2.0);
    mat.cAlbedo = vec3(a_x_snoise(vec3(rg * 30.0, 1.0)));
    mat.fSmoothness = 0.3;
    mat.fR0 = 0.1;
  } else {
    mat.cAlbedo = vec3(mod(fObjId, 2.0), mod(fObjId / 2.0, 2.0), mod(fObjId / 4.0, 2.0));
  }
  return mat;
}
vec3 a_x_GetSkyGradient(const in vec3 vDir) {
  float fBlend = vDir.y * 0.5 + 0.5;
  return mix(vec3(0.8, 1.6, 2.0), vec3(0.1, 0.1, 2.0), fBlend);
}
vec3 a_x_GetLightPos() {
  return vec3(5, 5, 0);
}
vec3 a_x_GetLightCol() {
  return vec3(18.0, 18.0, 6.0);
}
vec3 a_x_GetAmbientLight(const in vec3 vNormal) {
  return a_x_GetSkyGradient(vNormal);
}
void a_x_ApplyAtmosphere(inout vec3 col, const in a_x_C_Ray ray, const in a_x_C_HitInfo intersection) {
  float fFogDensity = 0.01;
  float fFogAmount = exp(intersection.fDistance * -fFogDensity);
  vec3 cFog = a_x_GetSkyGradient(ray.vDir);
  col = mix(cFog, col, fFogAmount);
  vec3 vToLight = a_x_GetLightPos() - ray.vOrigin;
  float fDot = dot(vToLight, ray.vDir);
  fDot = clamp(fDot, 0.0, intersection.fDistance);
  vec3 vClosestPoint = ray.vOrigin + ray.vDir * fDot;
  float fDist = length(vClosestPoint - a_x_GetLightPos());
  col += a_x_GetLightCol() * 0.05 / (fDist * fDist);
}
vec3 a_x_GetSceneNormal(const in vec3 vPos) {
  float fDelta = 0.01;
  vec3 vOffset1 = vec3(fDelta, -fDelta, -fDelta);
  vec3 vOffset2 = vec3(-fDelta, -fDelta, fDelta);
  vec3 vOffset3 = vec3(-fDelta, fDelta, -fDelta);
  vec3 vOffset4 = vec3(fDelta, fDelta, fDelta);
  float f1 = a_x_GetDistanceScene(vPos + vOffset1).x;
  float f2 = a_x_GetDistanceScene(vPos + vOffset2).x;
  float f3 = a_x_GetDistanceScene(vPos + vOffset3).x;
  float f4 = a_x_GetDistanceScene(vPos + vOffset4).x;
  vec3 vNormal = vOffset1 * f1 + vOffset2 * f2 + vOffset3 * f3 + vOffset4 * f4;
  return normalize(vNormal);
}
void a_x_Raymarch(const in a_x_C_Ray ray, out a_x_C_HitInfo result, const float fMaxDist, const int maxIter) {
  const float fEpsilon = 0.01;
  const float fStartDistance = 0.1;
  result.fDistance = fStartDistance;
  result.fObjectId = 0.0;
  for(int i = 0; i <= 128; i++) {
    result.vPos = ray.vOrigin + ray.vDir * result.fDistance;
    vec2 vSceneDist = a_x_GetDistanceScene(result.vPos);
    result.fObjectId = vSceneDist.y;
    if((abs(vSceneDist.x) <= fEpsilon) || (result.fDistance >= fMaxDist) || (i > maxIter)) {
      break;
    }
    result.fDistance = result.fDistance + vSceneDist.x;
  }
  if(result.fDistance >= fMaxDist) {
    result.fObjectId = 0.0;
    result.fDistance = 1000.0;
  }
}
float a_x_GetShadow(const in vec3 vPos, const in vec3 vLightDir, const in float fLightDistance) {
  a_x_C_Ray shadowRay;
  shadowRay.vDir = vLightDir;
  shadowRay.vOrigin = vPos;
  a_x_C_HitInfo shadowIntersect;
  a_x_Raymarch(shadowRay, shadowIntersect, fLightDistance, 32);
  return step(0.0, shadowIntersect.fDistance) * step(fLightDistance, shadowIntersect.fDistance);
}
float a_x_Schlick(const in vec3 vNormal, const in vec3 vView, const in float fR0, const in float fSmoothFactor) {
  float fDot = dot(vNormal, -vView);
  fDot = min(max((1.0 - fDot), 0.0), 1.0);
  float fDot2 = fDot * fDot;
  float fDot5 = fDot2 * fDot2 * fDot;
  return fR0 + (1.0 - fR0) * fDot5 * fSmoothFactor;
}
float a_x_GetDiffuseIntensity(const in vec3 vLightDir, const in vec3 vNormal) {
  return max(0.0, dot(vLightDir, vNormal));
}
float a_x_GetBlinnPhongIntensity(const in a_x_C_Ray ray, const in a_x_C_Material mat, const in vec3 vLightDir, const in vec3 vNormal) {
  vec3 vHalf = normalize(vLightDir - ray.vDir);
  float fNdotH = max(0.0, dot(vHalf, vNormal));
  float fSpecPower = exp2(4.0 + 6.0 * mat.fSmoothness);
  float fSpecIntensity = (fSpecPower + 2.0) * 0.125;
  return pow(fNdotH, fSpecPower) * fSpecIntensity;
}
float a_x_GetAmbientOcclusion(const in a_x_C_Ray ray, const in a_x_C_HitInfo intersection, const in vec3 vNormal) {
  vec3 vPos = intersection.vPos;
  float fAmbientOcclusion = 1.0;
  float fDist = 0.0;
  for(int i = 0; i <= 5; i++) {
    fDist += 0.1;
    vec2 vSceneDist = a_x_GetDistanceScene(vPos + vNormal * fDist);
    fAmbientOcclusion *= 1.0 - max(0.0, (fDist - vSceneDist.x) * 0.2 / fDist);
  }
  return fAmbientOcclusion;
}
vec3 a_x_GetObjectLighting(const in a_x_C_Ray ray, const in a_x_C_HitInfo intersection, const in a_x_C_Material material, const in vec3 vNormal, const in vec3 cReflection) {
  vec3 cScene;
  vec3 vLightPos = a_x_GetLightPos();
  vec3 vToLight = vLightPos - intersection.vPos;
  vec3 vLightDir = normalize(vToLight);
  float fLightDistance = length(vToLight);
  float fAttenuation = 1.0 / (fLightDistance * fLightDistance);
  float fShadowBias = 0.1;
  float fShadowFactor = a_x_GetShadow(intersection.vPos + vLightDir * fShadowBias, vLightDir, fLightDistance - fShadowBias);
  vec3 vIncidentLight = a_x_GetLightCol() * fShadowFactor * fAttenuation;
  vec3 vDiffuseLight = a_x_GetDiffuseIntensity(vLightDir, vNormal) * vIncidentLight;
  float fAmbientOcclusion = a_x_GetAmbientOcclusion(ray, intersection, vNormal);
  vec3 vAmbientLight = a_x_GetAmbientLight(vNormal) * fAmbientOcclusion;
  vec3 vDiffuseReflection = material.cAlbedo * (vDiffuseLight + vAmbientLight);
  vec3 vSpecularReflection = cReflection * fAmbientOcclusion;
  vSpecularReflection += a_x_GetBlinnPhongIntensity(ray, material, vLightDir, vNormal) * vIncidentLight;
  float fFresnel = a_x_Schlick(vNormal, ray.vDir, material.fR0, material.fSmoothness * 0.9 + 0.1);
  cScene = mix(vDiffuseReflection, vSpecularReflection, fFresnel);
  return cScene;
}
vec3 a_x_GetSceneColourSimple(const in a_x_C_Ray ray) {
  a_x_C_HitInfo intersection;
  a_x_Raymarch(ray, intersection, 16.0, 32);
  vec3 cScene;
  if(intersection.fObjectId < 0.5) {
    cScene = a_x_GetSkyGradient(ray.vDir);
  } else {
    a_x_C_Material material = a_x_GetObjectMaterial(intersection.fObjectId, intersection.vPos);
    vec3 vNormal = a_x_GetSceneNormal(intersection.vPos);
    vec3 cReflection = 5.0 * a_x_GetSkyGradient(reflect(ray.vDir, vNormal));
    cScene = a_x_GetObjectLighting(ray, intersection, material, vNormal, cReflection);
  }
  a_x_ApplyAtmosphere(cScene, ray, intersection);
  return cScene;
}
vec3 a_x_GetSceneColour(const in a_x_C_Ray ray) {
  a_x_C_HitInfo intersection;
  a_x_Raymarch(ray, intersection, 30.0, 256);
  vec3 cScene;
  if(intersection.fObjectId < 0.5) {
    cScene = a_x_GetSkyGradient(ray.vDir);
  } else {
    a_x_C_Material material = a_x_GetObjectMaterial(intersection.fObjectId, intersection.vPos);
    vec3 vNormal = a_x_GetSceneNormal(intersection.vPos);
    vec3 cReflection;{
      float fSepration = 0.05;
      a_x_C_Ray reflectRay;
      reflectRay.vDir = reflect(ray.vDir, vNormal);
      reflectRay.vOrigin = intersection.vPos + reflectRay.vDir * fSepration;
      cReflection = a_x_GetSceneColourSimple(reflectRay);
    }
    cScene = a_x_GetObjectLighting(ray, intersection, material, vNormal, cReflection);
  }
  a_x_ApplyAtmosphere(cScene, ray, intersection);
  return cScene;
}
void a_x_GetCameraRay(const in vec3 vPos, const in vec3 vForwards, const in vec3 vWorldUp, out a_x_C_Ray ray) {
  vec2 vUV = (gl_FragCoord.xy / resolution.xy);
  vec2 vViewCoord = vUV * 2.0 - 1.0;
  float fRatio = resolution.x / resolution.y;
  vViewCoord.y /= fRatio;
  ray.vOrigin = vPos;
  vec3 vRight = normalize(cross(vForwards, vWorldUp));
  vec3 vUp = cross(vRight, vForwards);
  ray.vDir = normalize(vRight * vViewCoord.x + vUp * vViewCoord.y + vForwards);
}
void a_x_GetCameraRayLookat(const in vec3 vPos, const in vec3 vInterest, out a_x_C_Ray ray) {
  vec3 vForwards = normalize(vInterest - vPos);
  vec3 vUp = vec3(0.0, 1.0, 0.0);
  a_x_GetCameraRay(vPos, vForwards, vUp, ray);
}
vec3 a_x_OrbitPoint(const in float fHeading, const in float fElevation) {
  return vec3(sin(fHeading) * cos(fElevation), sin(fElevation), cos(fHeading) * cos(fElevation));
}
vec3 a_x_Tonemap(const in vec3 cCol) {
  return cCol / (1.0 + cCol);
}
void a_x_main(void) {
  a_x_C_Ray ray;
  a_x_GetCameraRayLookat(a_x_OrbitPoint(-mouse.x * 5.0, mouse.y) * 5.0, vec3(0.0, 0.0, 0.0), ray);
  vec3 cScene = a_x_GetSceneColour(ray);
  float fExposure = 1.5;
  gl_FragColor = vec4(a_x_Tonemap(cScene * fExposure), 1.0);
}
#ifdef GL_ES

#endif

#define PI 3.14159265359

vec3 b_x_mod289(vec3 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}
vec4 b_x_mod289(vec4 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}
vec4 b_x_permute(vec4 x) {
  return b_x_mod289(((x * 34.0) + 1.0) * x);
}
vec4 b_x_taylorInvSqrt(vec4 r) {
  return 1.79284291400159 - 0.85373472095314 * r;
}
float b_x_snoise(vec3 v) {
  const vec2 C = vec2(1.0 / 6.0, 1.0 / 3.0);
  const vec4 D = vec4(0.0, 0.5, 1.0, 2.0);
  vec3 i = floor(v + dot(v, C.yyy));
  vec3 x0 = v - i + dot(i, C.xxx);
  vec3 g = step(x0.yzx, x0.xyz);
  vec3 l = 1.0 - g;
  vec3 i1 = min(g.xyz, l.zxy);
  vec3 i2 = max(g.xyz, l.zxy);
  vec3 x1 = x0 - i1 + C.xxx;
  vec3 x2 = x0 - i2 + C.yyy;
  vec3 x3 = x0 - D.yyy;
  i = b_x_mod289(i);
  vec4 p = b_x_permute(b_x_permute(b_x_permute(i.z + vec4(0.0, i1.z, i2.z, 1.0)) + i.y + vec4(0.0, i1.y, i2.y, 1.0)) + i.x + vec4(0.0, i1.x, i2.x, 1.0));
  float n_ = 0.142857142857;
  vec3 ns = n_ * D.wyz - D.xzx;
  vec4 j = p - 49.0 * floor(p * ns.z * ns.z);
  vec4 x_ = floor(j * ns.z);
  vec4 y_ = floor(j - 7.0 * x_);
  vec4 x = x_ * ns.x + ns.yyyy;
  vec4 y = y_ * ns.x + ns.yyyy;
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
  vec4 norm = b_x_taylorInvSqrt(vec4(dot(p0, p0), dot(p1, p1), dot(p2, p2), dot(p3, p3)));
  p0 *= norm.x;
  p1 *= norm.y;
  p2 *= norm.z;
  p3 *= norm.w;
  vec4 m = max(0.6 - vec4(dot(x0, x0), dot(x1, x1), dot(x2, x2), dot(x3, x3)), 0.0);
  m = m * m;
  return 42.0 * dot(m * m, vec4(dot(p0, x0), dot(p1, x1), dot(p2, x2), dot(p3, x3)));
}
mat2 b_x_m = mat2(0.80, 0.60, -0.60, 0.80);
float b_x_hash(float n) {
  return fract(sin(n) * 4375.5453);
}
float b_x_noise(in vec2 x) {
  vec2 p = floor(x);
  vec2 f = fract(x);
  f = f * f * (3.0 - 2.0 * f);
  float n = p.x + p.y * 57.0;
  float res = mix(mix(b_x_hash(n + 0.0), b_x_hash(n + 1.0), f.x), mix(b_x_hash(n + 57.0), b_x_hash(n + 58.0), f.x), f.y);
  return res;
}
float b_x_fbm(vec2 p) {
  float f = 0.0;
  f += 0.50000 * b_x_noise(p);
  p = b_x_m * p * 2.02;
  f += 0.25000 * b_x_noise(p);
  p = b_x_m * p * 2.03;
  f += 0.12500 * b_x_noise(p);
  p = b_x_m * p * 2.01;
  f += 0.06250 * b_x_noise(p);
  p = b_x_m * p * 2.04;
  f += 0.03125 * b_x_noise(p);
  return f / 0.984375;
}
float b_x_length2(vec2 p) {
  float ax = abs(p.x);
  float ay = abs(p.y);
  return pow(pow(ax, 4.0) + pow(ay, 4.0), 1.0 / 4.0);
}
vec4 b_x_main2(vec3 color) {
  vec2 q = gl_FragCoord.xy / resolution.xy;
  vec2 p = -1.6 + 3.2 * q;
  p.x *= resolution.x / resolution.y;
  float r = length(p);
  float a = atan(p.y, p.x);
  float dd = 0.2 * sin(0.7 * time);
  float ss = 1.0 + clamp(1.0 - r, 0.0, 1.0) * dd;
  r *= ss;
  float r2 = length(vec2(abs(p.x) + .6, p.y / ss)) * .26 * ss;
  vec3 col = vec3(0.5, 0.1, 0.1);
  float f = b_x_fbm(5.0 * p);
  col = mix(col, vec3(0.5, 0.2, 0.2), f);
  col = mix(col, vec3(0.9, 0.6, 0.2), 1.0 - smoothstep(0.2, 0.6, r));
  a += 0.05 * b_x_fbm(20.0 * p);
  f = smoothstep(0.3, 1.0, b_x_fbm(vec2(20.0 * a, 6.0 * r)));
  col = mix(col, vec3(1.0, 1.0, 1.0), f);
  f = smoothstep(0.4, 0.9, b_x_fbm(vec2(15.0 * a, 10.0 * r)));
  col *= 1.0 - 0.5 * f;
  col *= 1.0 - 0.25 * smoothstep(0.6, 0.8, r);
  f = 1.0 - smoothstep(0.0, 0.6, b_x_length2(mat2(0.6, 0.8, -0.8, 0.6) * (p - vec2(0.3, 0.5)) * vec2(1.0, 2.0)));
  col += vec3(1.0, 0.9, 0.9) * f * 0.985;
  col *= vec3(0.8 + 0.2 * cos(r * a));
  f = 1.0 - smoothstep(0.2, 0.25, r2);
  col = mix(col, vec3(0.0), f);
  f = smoothstep(0.79, 0.82, r);
  col = mix(col, color, f / 2.0);
  return vec4(col, 1.0);
}
void b_x_main(void) {
  vec2 p = (gl_FragCoord.xy / resolution.xy) - vec2(0.5);
  p.x *= resolution.x / resolution.y;
  p.y *= 1.4;
  p.x *= .7;
  float color1 = 3.0 - (3. * length(2. * p));
  float color2 = 3.0 - (3. * length(2. * p));
  for(int i = 1; i <= 8; i++) {
    float power = pow(2.0, float(i));
    color1 -= ((1.5 / power) * b_x_snoise(vec3((atan(p.y, p.x)) * power, (2. * length(p) - (time / 16.)) * power, (time / 8.))));
    color2 -= ((1.5 / power) * b_x_snoise(vec3((atan(p.y, -p.x) + 2. * PI) * power, (2. * length(p) - (time / 16.)) * power, (time / 8.))));
  }
  color1 *= smoothstep(PI, 0., (abs(atan(p.y, p.x))));
  color2 *= smoothstep(PI, 0., (abs(atan(p.y, -p.x))));
  float color = color1 + color2;
  vec3 c = vec3(color, pow(max(color, 0.), 2.) * 0.4, pow(max(color, 0.), 3.) * 0.15);
  gl_FragColor = b_x_main2(c);
}
int modulo(float x, float y) {
  return int(x - y * floor(x / y));
}
void main(void) {
  ivec2 m = ivec2(modulo(gl_FragCoord.x, 2.), modulo(gl_FragCoord.y, 2.));
  if(m.x == 0 || m.y == 0) {
    a_x_main();
  } else {
    b_x_main();
  }
}