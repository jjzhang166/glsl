// playing around with ray marching distance fields and lighting - @P_Malin
 

// ... modified Raymarch() function

// ...changed material setup

// ...fixed some compatability issues
// ...added orbit camera

// ...added detail effects (PerturbSceneNormalForObjects) - @eddbiddulph

#ifdef GL_ES
precision highp float;
#endif
 
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
 
struct C_Ray
{
	vec3 vOrigin;
	vec3 vDir;
};
 
struct C_HitInfo
{
	float fDistance;
	float fObjectId;
	vec3 vPos;
};
               
struct C_Material
{
	vec3 cAlbedo;
	float fR0;
	float fSmoothness;
};

 
// prototype for Ashima Arts perlin noise, defined at the bottom
float snoise(vec3 v);

// globally-accesible scene description
vec3 g_vSphere1Pos, g_vSphere2Pos;



vec2 DistCombineUnion( const in vec2 v1, const in vec2 v2 )
{
	//if(v1.x < v2.x)
	//            return v1;
	//else
	//            return v2;
	return mix(v1, v2, step(v2.x, v1.x));
}
 
vec2 DistCombineIntersect( const in vec2 v1, const in vec2 v2 )
{
	return mix(v2, v1, step(v2.x,v1.x));
}
 
vec2 DistCombineSubstract( const in vec2 v1, const in vec2 v2 )
{
	return DistCombineIntersect(v1, vec2(-v2.x, v2.y));
}
 
float GetDistanceSphere( const in vec3 vPos, const in vec3 vSphereOrigin, const in float fSphereRadius )
{
	return length(vPos - vSphereOrigin) - fSphereRadius;
}
 
float GetDistancePlane( const in vec3 vPos, const in vec3 vPlaneNormal, const in float fPlaneDist )
{
	return dot(vPos, vPlaneNormal) + fPlaneDist;
}
 
float GetBumpyFloorHeight(const in vec3 vPos)
{
	return ((sin((vPos.x + time) * 3.0)+sin(vPos.z * 3.0)) * 0.1 + 0.1);              
}
 
float GetDistanceBumpyFloor( const in vec3 vPos, const in float fHeight )
{
	return vPos.y - fHeight + GetBumpyFloorHeight(vPos);
}
 
void UpdateSceneConfiguration()
{
        g_vSphere1Pos = vec3( 1.75 + sin(time), -0.3, cos(time));
        g_vSphere2Pos = vec3(-1.75 - sin(time), -0.3, cos(time));

        g_vSphere1Pos.y -= GetBumpyFloorHeight(g_vSphere1Pos);
        g_vSphere2Pos.y -= GetBumpyFloorHeight(g_vSphere2Pos);
}

 vec2 GetDistanceScene( const in vec3 vPos )
{             
	vec2 vDistPlane1 = vec2(GetDistanceBumpyFloor( vPos, -1.0 ), 1.0);
        
        vec2 vDistSphere1 = vec2(GetDistanceSphere( vPos, g_vSphere1Pos, 0.75 ), 2.0);

        vec2 vDistSphere2 = vec2(GetDistanceSphere( vPos, g_vSphere2Pos, 0.75 ), 3.0);
               
        vec2 vResult = DistCombineUnion(vDistSphere1, vDistSphere2);
        vResult = DistCombineUnion(vDistPlane1, vResult);
               
        return vResult;
}
 
 
C_Material GetObjectMaterial( in float fObjId, in vec3 vPos )
{
	C_Material mat;
 
	mat.fR0 = 0.1;
	mat.fSmoothness = 0.5;
 
 	if(fObjId < 1.5)
        {
		vec2 vTile = step(fract(vec2(vPos.x + time, vPos.z)), vec2(0.5));
		float fBlend = mod(vTile.x + vTile.y, 2.0);
		mat.cAlbedo = mix(vec3(1.0,0.1, 0.1), vec3(0.1,0.1, 1.0), fBlend);
		mat.fSmoothness = 0.3;
		mat.fR0 = 0.01;
	}
	else
	{	
		mat.cAlbedo = vec3( mod(fObjId, 2.0), mod(fObjId / 2.0, 2.0), mod(fObjId/4.0, 2.0));
	}
	
	return mat;
}

// extract perlin noise gradient via forward differencing. yes, there is an
// analytical solution, but it was quick to write this.
vec3 PerlinGradient3D( const in vec3 vPos )
{
	float fDelta = 0.01;

    float fC = snoise(vPos);
    
    vec3 vGradient = vec3( snoise(vPos + vec3(fDelta, 0.0, 0.0)) - fC,
                           snoise(vPos + vec3(0.0, fDelta, 0.0)) - fC,
                           snoise(vPos + vec3(0.0, 0.0, fDelta)) - fC );
                           
    return vGradient;
}

vec3 rotateZ(vec3 v, float a)
{
	return vec3(cos(a) * v.x - sin(a) * v.y, sin(a) * v.x + cos(a) * v.y, v.z);
}

vec3 rotateY(vec3 v, float a)
{
	return vec3(cos(a) * v.x - sin(a) * v.z, v.y, sin(a) * v.x + cos(a) * v.z);
}

vec3 rotateX(vec3 v, float a)
{
	return vec3(v.x, cos(a) * v.y - sin(a) * v.z, sin(a) * v.y + cos(a) * v.z);
}
        
vec3 PerturbSceneNormalForObjects( const in vec3 vPos, const in float fObjectId, const in vec3 vNormal )
{
    vec3 vPerturbedNormal = vNormal;

    if(fObjectId == 2.0)
    {
        // perturb normal for sphere 1
        vec3 vGrad = PerlinGradient3D(rotateZ(rotateY((vPos - g_vSphere1Pos) * 10.0, time), time * 2.0));
        vec3 vProjGrad = vGrad - vNormal * dot(vNormal, vGrad);
        vPerturbedNormal -= vProjGrad * 0.3;
    }
    else if(fObjectId == 3.0)
    {
        // perturb normal for sphere 2
        vec3 vGrad = PerlinGradient3D(rotateZ(rotateY((vPos - g_vSphere2Pos) * 8.0, -time), -time * 2.0));
        vec3 vProjGrad = vGrad - vNormal * dot(vNormal, vGrad);
        vPerturbedNormal -= vProjGrad * 0.2;
    }
    
    return vPerturbedNormal;
}

vec3 GetSceneNormal( const in vec3 vPos, const in float fObjectId )
{
	float fDelta = 0.01;
	
	float fDx = GetDistanceScene( vPos + vec3(fDelta, 0.0, 0.0) ).x - GetDistanceScene( vPos + vec3(-fDelta, 0.0, 0.0) ).x;
	float fDy = GetDistanceScene( vPos + vec3(0.0, fDelta, 0.0) ).x - GetDistanceScene( vPos + vec3(0.0, -fDelta, 0.0) ).x;
	float fDz = GetDistanceScene( vPos + vec3(0.0, 0.0, fDelta) ).x - GetDistanceScene( vPos + vec3(0.0, 0.0, -fDelta) ).x;
	
	vec3 vNormal = vec3( fDx, fDy, fDz );

    vNormal = PerturbSceneNormalForObjects( vPos, fObjectId, vNormal );
	
	return normalize( vNormal );
}
 
// This is an excellent resource on ray marching -> http://www.iquilezles.org/www/articles/distfunctions/distfunctions.htm
void Raymarch( const in C_Ray ray, out C_HitInfo result )
{            
	const float fMaxDist = 100.0;
	const float fEpsilon = 0.01;
	const float fStartDistance = 0.1;
	
	result.fDistance = fStartDistance; 
	result.fObjectId = 0.0;
		      
	for(int i=0;i<=256;i++)                  
	{
		result.vPos = ray.vOrigin + ray.vDir * result.fDistance;
		vec2 vSceneDist = GetDistanceScene( result.vPos );
		result.fObjectId = vSceneDist.y;
		
		// abs allows backward stepping - should only be necessary for non uniform distance functions
		if((abs(vSceneDist.x) <= fEpsilon) || (result.fDistance >= fMaxDist))
		{
			break;
		}                            
		
		result.fDistance = result.fDistance + vSceneDist.x;                          
	}
	
	
	if(result.fDistance >= fMaxDist)
	{
		result.fObjectId = 0.0;
		result.fDistance = 1000.0;
	}
}
 
vec3 GetSkyGradient( const in vec3 vDir )
{
	float fBlend = vDir.y * 0.5 + 0.5;
	return mix(vec3(0.8, 1.6, 2.0), vec3(0.1, 0.1, 2.0), fBlend);
}
 
float GetShadow( const in vec3 vPos, const in vec3 vLightDir, const in float fLightDistance )
{
	C_Ray shadowRay;
	shadowRay.vDir = vLightDir;
	shadowRay.vOrigin = vPos;
	
	C_HitInfo shadowIntersect;
	Raymarch(shadowRay, shadowIntersect);
				       
	return step(0.0, shadowIntersect.fDistance) * step(fLightDistance, shadowIntersect.fDistance );             
}
 
// http://en.wikipedia.org/wiki/Schlick's_approximation
float Schlick( const in vec3 vNormal, const in vec3 vView, const in float fR0, const in float fSmoothFactor)
{
	float fDot = dot(vNormal, -vView);
	fDot = max((1.0 - fDot), 0.0);
	float fDot2 = fDot * fDot;
	float fDot5 = fDot2 * fDot2 * fDot;
	return fR0 + (1.0 - fR0) * fDot5 * fSmoothFactor;
}
 
vec3 GetLightPos()
{
	return vec3(sin(time), 1.5 + cos(time * 1.231), cos(time * 1.1254));
}
 
vec3 GetLightCol()
{
	return vec3(18.0, 18.0, 6.0);
}
 
float GetDiffuseIntensity(const in vec3 vLightDir, const in vec3 vNormal)
{
	return max(0.0, dot(vLightDir, vNormal));
}
 
float GetBlinnPhongIntensity(const in C_Ray ray, const in C_Material mat, const in vec3 vLightDir, const in vec3 vNormal)
{             
	vec3 vHalf = normalize(vLightDir - ray.vDir);
	float fNdotH = max(0.0, dot(vHalf, vNormal));

	float fSpecPower = exp2(4.0 + 6.0 * mat.fSmoothness);
	float fSpecIntensity = (fSpecPower + 2.0) * 0.125;
	
	return pow(fNdotH, fSpecPower) * fSpecIntensity;
}
 
vec3 GetAmbientLight(const in vec3 vNormal)
{
	return GetSkyGradient(vNormal);
}
 
// use distance field to evaluate ambient occlusion
float GetAmbientOcclusion(const in C_Ray ray, const in C_HitInfo intersection, const in vec3 vNormal)
{
	vec3 vPos = intersection.vPos;

	float fAmbientOcclusion = 1.0;
       
	float fDist = 0.0;
	for(int i=0; i<=5; i++)
	{
		fDist += 0.1;

		vec2 vSceneDist = GetDistanceScene(vPos + vNormal * fDist);
		
		fAmbientOcclusion *= 1.0 - max(0.0, (fDist - vSceneDist.x) * 0.2 / fDist );		       
	}
       
	return fAmbientOcclusion;
}
 
void ApplyAtmosphere(inout vec3 col, const in C_Ray ray, const in C_HitInfo intersection)
{
	// fog
	float fFogDensity = 0.01;
	float fFogAmount = exp(intersection.fDistance * -fFogDensity);
	vec3 cFog = GetSkyGradient(ray.vDir);
	col = mix(cFog, col, fFogAmount);

	// glare from light (a bit hacky - use length of closest approach from ray to light)
	vec3 vToLight = GetLightPos() - ray.vOrigin;
	float fDot = dot(vToLight, ray.vDir);
	fDot = clamp(fDot, 0.0, intersection.fDistance);
       
	vec3 vClosestPoint = ray.vOrigin + ray.vDir * fDot;
	float fDist = length(vClosestPoint - GetLightPos());
	col += GetLightCol() * 0.05/ (fDist * fDist);

}
 
 
vec3 GetObjectLighting(const in C_Ray ray, const in C_HitInfo intersection, const in vec3 vNormal, vec3 cReflection)
{
	vec3 cScene ;
	
	vec3 vLightPos = GetLightPos();
	vec3 vToLight = vLightPos - intersection.vPos;
	vec3 vLightDir = normalize(vToLight);
	float fLightDistance = length(vToLight);
	
	float fAttenuation = 1.0 / (fLightDistance * fLightDistance);
	float fShadowBias = 0.1;
	float fShadowFactor = GetShadow( intersection.vPos + vLightDir * fShadowBias, vLightDir, fLightDistance - fShadowBias );
	vec3 vIncidentLight = GetLightCol() * fShadowFactor * fAttenuation;
	
	vec3 vDiffuseLight = GetDiffuseIntensity( vLightDir, vNormal ) * vIncidentLight;
	float fAmbientOcclusion = GetAmbientOcclusion(ray, intersection, vNormal);
	vec3 vAmbientLight = GetAmbientLight(vNormal) * fAmbientOcclusion;
	
	C_Material mat = GetObjectMaterial(intersection.fObjectId, intersection.vPos);
	vec3 vDiffuseReflection = mat.cAlbedo * (vDiffuseLight + vAmbientLight);
	
	vec3 vSpecularReflection = cReflection;
		       
	vSpecularReflection += GetBlinnPhongIntensity( ray, mat, vLightDir, vNormal ) * vIncidentLight;
		       
	float fFresnel = Schlick(vNormal, ray.vDir, mat.fR0, mat.fSmoothness * 0.9 + 0.1);
	cScene = mix(vDiffuseReflection , vSpecularReflection, fFresnel);
	
	return cScene;
}
 
vec3 GetSceneColourSimple( const in C_Ray ray )
{
	C_HitInfo intersection;
	Raymarch(ray, intersection);
		       
	vec3 cScene;
	
	if(intersection.fObjectId < 0.5)
	{
		cScene = GetSkyGradient(ray.vDir);
	}
	else
	{
		vec3 vNormal = GetSceneNormal(intersection.vPos, intersection.fObjectId);
        
		// use sky gradient instead of reflection
		vec3 cReflection = GetSkyGradient(reflect(ray.vDir, vNormal));
		
		// apply lighting
		cScene = GetObjectLighting(ray, intersection, vNormal, cReflection );
	}
	
	ApplyAtmosphere(cScene, ray, intersection);
	
	return cScene;
}
 
 
vec3 GetSceneColour( const in C_Ray ray )
{                                                             
	C_HitInfo intersection;
	Raymarch(ray, intersection);
		       
	vec3 cScene;
	
	if(intersection.fObjectId < 0.5)
	{
		cScene = GetSkyGradient(ray.vDir);
	}
	else
	{
		vec3 vNormal = GetSceneNormal(intersection.vPos, intersection.fObjectId);
		
		// get colour from reflected ray
		float fSepration = 0.05;
		C_Ray reflectRay;
		reflectRay.vDir = reflect(ray.vDir, vNormal);
		reflectRay.vOrigin = intersection.vPos + reflectRay.vDir * fSepration;
				
		vec3 cReflection = GetSceneColourSimple(reflectRay);                                                 
		
		// apply lighting
		cScene = GetObjectLighting(ray, intersection, vNormal, cReflection );
	}
	
	ApplyAtmosphere(cScene, ray, intersection);
	
	return cScene;
}
 
void GetCameraRay( const in vec3 vPos, const in vec3 vForwards, const in vec3 vWorldUp, out C_Ray ray)
{
	vec2 vUV = ( gl_FragCoord.xy / resolution.xy );
	vec2 vViewCoord = vUV * 2.0 - 1.0;
	
	float fRatio = resolution.x / resolution.y;
	
	vViewCoord.y /= fRatio;                              
	
	ray.vOrigin = vPos;
	
	vec3 vRight = normalize(cross(vForwards, vWorldUp));
	vec3 vUp = cross(vRight, vForwards);
	       
	ray.vDir = normalize( vRight * vViewCoord.x + vUp * vViewCoord.y + vForwards);           
}
 
void GetCameraRayLookat( const in vec3 vPos, const in vec3 vInterest, out C_Ray ray)
{
	vec3 vForwards = normalize(vInterest - vPos);
	vec3 vUp = vec3(0.0, 1.0, 0.0);
	
	GetCameraRay(vPos, vForwards, vUp, ray);
}
 
vec3 OrbitPoint( const in float fHeading, const in float fElevation )
{
	return vec3(sin(fHeading) * cos(fElevation), sin(fElevation), cos(fHeading) * cos(fElevation));
}
 
vec3 Tonemap( const in vec3 cCol )
{
	// simple Reinhard tonemapping operator
	
	return cCol / (1.0 + cCol);
}
 
void main( void )
{
	C_Ray ray;
	
    UpdateSceneConfiguration();
    
	GetCameraRayLookat( OrbitPoint(-mouse.x * 5.0, mouse.y) * 5.0, vec3(0.0, 0.0, 0.0), ray);
	//GetCameraRayLookat(vec3(0.0, 0.0, -5.0), vec3(0.0, 0.0, 0.0), ray);
	
	vec3 cScene = GetSceneColour( ray );
	
	float fExposure = 1.5;
	gl_FragColor = vec4( Tonemap(cScene * fExposure), 1.0 );
}

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

vec3 mod289(vec3 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec4 mod289(vec4 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec4 permute(vec4 x) {
     return mod289(((x*34.0)+1.0)*x);
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
  i = mod289(i);
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
