#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// playing around with ray marching distance fields and lighting - @P_Malin

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
	return length(vPos - vSphereOrigin) - fSphereRadius + length(sin((vPos-vSphereOrigin)*10.0)*0.1);
}

float GetDistancePlane( const in vec3 vPos, const in vec3 vPlaneNormal, const in float fPlaneDist )
{
	return dot(vPos, vPlaneNormal) + fPlaneDist;
}

float GetBumpyFloorHeight(const in vec3 vPos)
{
	return (sin((vPos.x + time) * 3.0) * 0.1 + 0.1) + (sin((vPos.z) * 3.0) * 0.1 + 0.1);
}

float GetDistanceBumpyFloor( const in vec3 vPos, const in float fHeight )
{
	return vPos.y - fHeight + GetBumpyFloorHeight(vPos);
}


vec2 GetDistanceScene( const in vec3 vPos )
{
	vec2 vDistPlane1 = vec2(GetDistanceBumpyFloor( vPos, -1.0 ), 1.0);
	vec3 vSphere1Pos = vec3( 1.75 + sin(time), -0.25, 5.0 + cos(time));
	vSphere1Pos.y -= GetBumpyFloorHeight(vSphere1Pos);
	vec2 vDistSphere1 = vec2(GetDistanceSphere( vPos, vSphere1Pos, 0.75 ), 2.0);
	vec3 vSphere2Pos = vec3(-1.75 - sin(time), -0.25, 5.0 - cos(time));
	vSphere2Pos.y -= GetBumpyFloorHeight(vSphere2Pos);
	vec2 vDistSphere2 = vec2(GetDistanceSphere( vPos, vSphere2Pos, 0.75 ), 3.0);
	
	vec2 vResult = DistCombineUnion(vDistSphere1, vDistSphere2);
	vResult = DistCombineUnion(vResult, vDistPlane1);
	return vResult;
}

vec3 GetSceneNormal( const in vec3 vPos )
{
	float fDelta = 0.001;
	
	float fDx = GetDistanceScene( vPos + vec3(fDelta, 0.0, 0.0) ).x - GetDistanceScene( vPos + vec3(-fDelta, 0.0, 0.0) ).x;
	float fDy = GetDistanceScene( vPos + vec3(0.0, fDelta, 0.0) ).x - GetDistanceScene( vPos + vec3(0.0, -fDelta, 0.0) ).x;
	float fDz = GetDistanceScene( vPos + vec3(0.0, 0.0, fDelta) ).x - GetDistanceScene( vPos + vec3(0.0, 0.0, -fDelta) ).x;
	
	vec3 vNormal = vec3( fDx, fDy, fDz );

	return normalize( vNormal );
}

// This is an excellent resource on ray marching -> http://www.iquilezles.org/www/articles/distfunctions/distfunctions.htm
void Raymarch( const in C_Ray ray, out C_HitInfo result )
{
	const float fMaxDist = 30.0;
	const float fEpsilon = 0.01;
	
	result.fDistance = 0.0;
	result.fObjectId = 0.0;
		
 	for(int i=0;i<128;i++)		
	{
		result.vPos = ray.vOrigin + ray.vDir * result.fDistance;
		vec2 vSceneDist = GetDistanceScene( result.vPos );
		result.fObjectId = vSceneDist.y;
		if(vSceneDist.x <= fEpsilon)
		{
			break;
		}
		
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

	mat.fR0 = 0.0;
	mat.fSpecPower = 100.0;
	mat.fSpecIntensity = 5.0;
	
	if(fObjId < 0.5)
	{
		mat.cAlbedo = vec3(0.3, 0.8, 0.9);
	}
	else if(fObjId < 1.5)
	{
		float fBlend = mod(floor(fract(vPos.x + time) *2.0) + floor(fract(vPos.z) * 2.0), 2.0);
		mat.cAlbedo = vec3(1.0,0.1, 0.1) * fBlend + vec3(0.1,0.1, 1.0) * (1.0 - fBlend);
		mat.fSpecPower = 50.0;
		mat.fSpecIntensity = 2.0;
	}
	else
	{
		mat.fR0 = 0.1;
		
		mat.cAlbedo = vec3( mod(fObjId, 2.0), mod(fObjId / 2.0, 2.0), mod(fObjId/4.0, 2.0));
	}
	
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

// Schlick's approximation to fresnel (but using ^4 not ^5)
// http://en.wikipedia.org/wiki/Schlick's_approximation
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
	return vec3(0.0 + sin(time), 1.0 + cos(time * 1.231), 5.0);
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
	//return GetSkyGradient(vNormal) * 0.5;
	return vec3(0.1, 0.3, 0.5);
}

// use distance field to evaluate ambient occlusion
float GetAmbientOcclusion(const in C_Ray ray, const in C_HitInfo intersection, const in vec3 vNormal)
{
	vec3 vPos = intersection.vPos;

	float fAmbientOcclusion = 1.0;
	
	float fDist = 0.0;
	for(int i=0; i<5; i++)
	{
		fDist += 0.1;

		vec2 vSceneDist = GetDistanceScene(vPos + vNormal * fDist);
		
		fAmbientOcclusion *= 1.0 - max(0.0, (fDist - vSceneDist.x) * 0.2 / fDist );
		
	}
	
	return fAmbientOcclusion;
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
	
	// simple Reinhard tonemapping operator
	float fExposure = 1.5;
	vec3 cFinal = cScene * fExposure;
	cFinal = cFinal / (1.0 + cFinal);

	gl_FragColor = vec4( cFinal, 1.0 );
}
