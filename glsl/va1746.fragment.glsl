#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// playing around with ray marching distance fields and lighting - @P_Malin

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

// Classic Perlin noise
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
  return n_xyz;
}

float surface3 ( vec3 coord ) {
	
	float frequency = 4.0;
	float n = 0.0;	
		
	n += 0.33	* ( 0.5+2.0*cnoise( coord * frequency ) );
	n += 0.33	* ( 0.5+2.0*cnoise( coord * frequency * 2.0 ) );
	n += 0.33	* ( 0.5+2.0*cnoise( coord * frequency * 1.0 ) );
	n += 0.33	* ( 0.5+2.0*cnoise( coord * frequency * 2.0 ) );
	
	return n;
}

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
	float fSpecPower;
	float fSpecIntensity;
};
	
void GetCameraRay( out C_Ray ray)
{	
	vec2 vUV = ( gl_FragCoord.xy / resolution.xy );
	vec2 vViewCoord = vUV * 2.0 - 1.0;
	
	float fRatio = resolution.x / resolution.y;
	
	vViewCoord.y /= fRatio;

	ray.vOrigin = vec3(0.0, 0.0, 0.0);
	ray.vDir = normalize( vec3(vViewCoord, 1.0) );
}

vec2 DistCombineUnion( const in vec2 v1, const in vec2 v2 )
{
	vec2 result = v2;
	if(v1.x < v2.x)
		return v1;
	else
		return v2;
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
	float fOffset=time*0.1;
	return surface3((vPos/10.0)+vec3(0.0,fOffset,0.0));
	return (sin((vPos.x + time) * 3.0) * 0.1 + 0.1) + (sin((vPos.z) * 3.0) * 0.1 + 0.1);
}

float GetDistanceBumpyFloor( const in vec3 vPos, const in float fHeight )
{
	return vPos.y - fHeight + GetBumpyFloorHeight(vPos);
}


vec2 GetDistanceScene( const in vec3 vPos )
{
	vec2 vDistPlane1 = vec2(GetDistanceBumpyFloor( vPos, -1.0 ), 1.0);
	//vec3 vSphere1Pos = vec3( 1.75 + sin(time), -0.25, 5.0 + cos(time));
	//vSphere1Pos.y -= GetBumpyFloorHeight(vSphere1Pos);
	//vec2 vDistSphere1 = vec2(GetDistanceSphere( vPos, vSphere1Pos, 0.75 ), 2.0);
	//vec3 vSphere2Pos = vec3(-1.75 - sin(time), -0.25, 5.0 - cos(time));
	//vSphere2Pos.y -= GetBumpyFloorHeight(vSphere2Pos);
	//vec2 vDistSphere2 = vec2(GetDistanceSphere( vPos, vSphere2Pos, 0.75 ), 3.0);
	
	//vec2 vResult = vec2(0.0,0.0); //DistCombineUnion(vDistSphere1, vDistSphere2);
	//vResult = DistCombineUnion(vResult, vDistPlane1);
	return vDistPlane1;
}

vec3 GetSceneNormal( const in vec3 vPos )
{
	vec3 vDelta=vec3(0.001,-0.001,0.0);

	return normalize(vec3(
		GetDistanceScene( vPos + vDelta.xzz ).x - GetDistanceScene( vPos + vDelta.yzz ).x,
		GetDistanceScene( vPos + vDelta.zxz ).x - GetDistanceScene( vPos + vDelta.zyz ).x,
		GetDistanceScene( vPos + vDelta.zzx ).x - GetDistanceScene( vPos + vDelta.zzy ).x));
}

void Raymarch( const in C_Ray ray, out C_HitInfo result )
{
	const float fMaxDist = 30.0;
	const float fEpsilon = 0.01;
	
	result.fDistance = 0.0;
	result.fObjectId = 0.0;
		
 	for(int i=0;i<64;i++)		
	{
		result.vPos = ray.vOrigin + ray.vDir * result.fDistance;
		vec2 vSceneDist = GetDistanceScene( result.vPos );
		result.fObjectId = vSceneDist.y;
		//if(vSceneDist.x <= fEpsilon)
		//{
		//	break;
		//}
		
		result.fDistance += vSceneDist.x;
		
		if(result.fDistance > fMaxDist)
		{
			result.vPos = ray.vOrigin + ray.vDir * result.fDistance;
			result.fDistance = fMaxDist;
			result.fObjectId = 0.0;
			break;
		}
	}

}

C_Material GetObjectMaterial( in float fObjId, in vec3 vPos )
{
	C_Material mat;

/*	mat.fR0 = 0.0;
	mat.fSpecPower = 100.0;
	mat.fSpecIntensity = 5.0;
	
	if(fObjId < 0.5)
	{
		mat.cAlbedo = vec3(0.3, 0.8, 0.9);
	}
	else if(fObjId < 1.5)
	{*/
	//	float fBlend = mod(floor(fract(vPos.x + time) *2.0) + floor(fract(vPos.z) * 2.0), 2.0);
		mat.cAlbedo = vec3(0.0,0.0, 0.8); //* fBlend + vec3(0.1,0.1, 1.0) * (1.0 - fBlend);
		mat.fSpecPower = 32.0;
		mat.fSpecIntensity = 4.0;
/*	}
	else
	{
		mat.fR0 = 0.1;
		
		mat.cAlbedo = vec3( mod(fObjId, 2.0), mod(fObjId / 2.0, 2.0), mod(fObjId/4.0, 2.0));
	}*/
	
	return mat;
}

vec3 GetSkyGradient( const in vec3 vDir )
{
	float fBlend = vDir.y * 0.5 + 0.5;
	return vec3(0.0, 0.0, 1.0) * fBlend + vec3(0.4, 1.0, 1.0) * (1.0 - fBlend);

}

float GetShadow( const in C_Ray ray, const in C_HitInfo intersection, const in vec3 vLightDir, const in float fLightDistance )
{
	float fSepration = 0.1;
	C_Ray shadowRay;
	shadowRay.vDir = vLightDir;
	shadowRay.vOrigin = intersection.vPos + shadowRay.vDir * fSepration;

	C_HitInfo shadowIntersect;
	Raymarch(shadowRay, shadowIntersect);
			
	if((shadowIntersect.fDistance >= 0.0) && (shadowIntersect.fDistance <= fLightDistance))
	{
		return 0.0;
	}
	
	return 1.0;
	
}

float Schlick4( const in vec3 vNormal, const in vec3 vView, const in float fR0)
{
	float fDot = dot(vNormal, -vView);
	fDot = max((1.0 - fDot), 0.0);
	float fDot2 = fDot * fDot;
	float fDot4 = fDot2 * fDot2;
	return fR0 + (1.0 - fR0) * fDot4;
}

vec3 GetLightPos()
{
	return vec3(((mouse.x*2.0)-1.0)*6.0, (1.2+(mouse.y*2.0)-1.0)*2.0, 5.0);
}

vec3 GetLightCol()
{
	return vec3(6.0, 6.0, 2.0);
}

float GetDiffuseIntensity(const in vec3 vLightDir, const in vec3 vNormal)
{
	return max(0.0, dot(vLightDir, vNormal));
}

float GetBlinnPhongIntensity(const in C_Ray ray, const in C_Material mat, const in vec3 vLightDir, const in vec3 vNormal)
{	
	vec3 vHalf = normalize(vLightDir - ray.vDir);
	float fNdotH = max(0.0, dot(vHalf, vNormal));

	return pow(fNdotH, mat.fSpecPower) * mat.fSpecIntensity;
}

vec3 GetAmbientLight(const in vec3 vNormal)
{
	return GetSkyGradient(vNormal) * 0.5;
//	return vec3(0.5, 0.8, 0.5);
}

float GetAmbientOcclusion(const in C_Ray ray, const in C_HitInfo intersection, const in vec3 vNormal)
{
	vec3 vPos = intersection.vPos;

	float fAo = 1.0;
	
	float fDist = 0.0;
	for(int i=0; i<5; i++)
	{
		fDist += 0.1;

		vec2 vSceneDist = GetDistanceScene(vPos + vNormal * fDist);
		
		fAo *= 1.0 - max(0.0, (fDist - vSceneDist.x) * 0.2 / fDist );
		
	}
	
	return fAo;
}

void ApplyAtmosphere(inout vec3 col, const in C_Ray ray, const in C_HitInfo intersection)
{
	// glare from light (a bit hacky - use length of closest approach from ray to light)
	vec3 vToLight = GetLightPos() - ray.vOrigin;
	float fDot = dot(vToLight, ray.vDir);
	fDot = clamp(fDot, 0.0, intersection.fDistance);
	
	vec3 vClosestPoint = ray.vOrigin + ray.vDir * fDot;
	float fDist = length(vClosestPoint - GetLightPos());
	col += GetLightCol() * 0.05/ (fDist * fDist);

	// fog
	float fFogDensity = 0.015;
	float fFogAmount = exp(intersection.fDistance * -fFogDensity);
	vec3 cFog = vec3(0.5, 0.8, 1.0);
	col = col * fFogAmount + cFog * (1.0 - fFogAmount);


}


vec3 GetObjectLighting(const in C_Ray ray, const in C_HitInfo intersection, const in vec3 vNormal, vec3 cReflection)
{
	vec3 cScene ;
	
	vec3 vLightPos = GetLightPos();
	vec3 vToLight = vLightPos - intersection.vPos;
	vec3 vLightDir = normalize(vToLight);
	float fLightDistance = length(vToLight);

	float fAttenuation = 1.0 / (fLightDistance * fLightDistance);
	float fShadowFactor = GetShadow( ray, intersection, vLightDir, fLightDistance );
	vec3 vIncidentLight = GetLightCol() * fShadowFactor * fAttenuation;

	vec3 vDiffuseLight = GetDiffuseIntensity( vLightDir, vNormal ) * vIncidentLight;
	float fAmbientOcclusion = GetAmbientOcclusion(ray, intersection, vNormal);
	vec3 vAmbientLight = GetAmbientLight(vNormal) * fAmbientOcclusion;

	C_Material mat = GetObjectMaterial(intersection.fObjectId, intersection.vPos);
	vec3 vDiffuseReflection = mat.cAlbedo * (vDiffuseLight + vAmbientLight);
	
	vec3 vSpecularReflection = vec3(0.0);
	
	vSpecularReflection += cReflection;
	
	vSpecularReflection += GetBlinnPhongIntensity( ray, mat, vLightDir, vNormal ) * vIncidentLight;
		
	float fFresnel = Schlick4(vNormal, ray.vDir, mat.fR0);
	cScene = vDiffuseReflection * (1.0 - fFresnel) + vSpecularReflection * fFresnel;

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
		vec3 vNormal = GetSceneNormal(intersection.vPos);
	
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
		vec3 vNormal = GetSceneNormal(intersection.vPos);
	
		// get colour from reflected ray
		float fSepration = 0.1;
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

void main( void ) 
{
	C_Ray ray;
	
	GetCameraRay(ray);
	
	vec3 cScene = GetSceneColour( ray );
	
	float fExposure = 1.5;
	vec3 cFinal = cScene * fExposure;
	cFinal = cFinal / (1.0 + cFinal);

	gl_FragColor = vec4( cFinal, 1.0 );
}
