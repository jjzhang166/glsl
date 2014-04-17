//aparajith and himanshu

// playing around with ray marching distance fields and lighting - @P_Malin
 
// .. updated framework with changes & bug fixes from chains code

// ... modified Raymarch() function

// ...changed material setup

// ...fixed some compatability issues
// ...added orbit camera

#ifdef GL_ES
precision highp float;
#endif
 
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


//For noise

vec4 _mod289(vec4 x)
{
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec3 _mod289(vec3 x)
{
    return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec2 _mod289(vec2 x) 
{
    return x - floor(x * (1.0 / 289.0)) * 289.0;
}

float _mod289(float x)
{
    return x - floor(x * (1.0 / 289.0)) * 289.0;
}
  
vec4 _permute(vec4 x)
{
    return _mod289(((x*34.0)+1.0)*x);
}

vec3 _permute(vec3 x)
{
    return _mod289(((x*34.0)+1.0)*x);
}

float _permute(float x) 
{
    return _mod289(((x*34.0)+1.0)*x);
}

vec4 _taylorInvSqrt(vec4 r)
{
    return 1.79284291400159 - 0.85373472095314 * r;
}

float _taylorInvSqrt(float r)
{
    return 1.79284291400159 - 0.85373472095314 * r;
}

vec4 _grad4(float j, vec4 ip)
{
    const vec4 ones = vec4(1.0, 1.0, 1.0, -1.0);
    vec4 p,s;

    p.xyz = floor( fract (vec3(j) * ip.xyz) * 7.0) * ip.z - 1.0;
    p.w = 1.5 - dot(abs(p.xyz), ones.xyz);
    s = vec4(lessThan(p, vec4(0.0)));
    p.xyz = p.xyz + (s.xyz*2.0 - 1.0) * s.www; 

    return p;
}
  
/*
 * Implemented by Ian McEwan, Ashima Arts, and distributed under the MIT License.  {@link https://github.com/ashima/webgl-noise}
 */  

float snoise(vec3 v)
{ 
    const vec2  C = vec2(1.0/6.0, 1.0/3.0) ;
    const vec4  D = vec4(0.0, 0.5, 1.0, 2.0);

    // First corner
    vec3 i  = floor(v + dot(v, C.yyy) );
    vec3 x0 =   v - i + dot(i, C.xxx) ;

    // Other corners
    vec3 g = step(x0.yzx, x0.xyz);
    vec3 l = 1.0 - g;
    vec3 i1 = min( g.xyz, l.zxy );
    vec3 i2 = max( g.xyz, l.zxy );

    //   x0 = x0 - 0.0 + 0.0 * C.xxx;
    //   x1 = x0 - i1  + 1.0 * C.xxx;
    //   x2 = x0 - i2  + 2.0 * C.xxx;
    //   x3 = x0 - 1.0 + 3.0 * C.xxx;
    vec3 x1 = x0 - i1 + C.xxx;
    vec3 x2 = x0 - i2 + C.yyy; // 2.0*C.x = 1/3 = C.y
    vec3 x3 = x0 - D.yyy;      // -1.0+3.0*C.x = -0.5 = -D.y

    // Permutations
    i = _mod289(i); 
    vec4 p = _permute( _permute( _permute( 
                i.z + vec4(0.0, i1.z, i2.z, 1.0 ))
              + i.y + vec4(0.0, i1.y, i2.y, 1.0 )) 
              + i.x + vec4(0.0, i1.x, i2.x, 1.0 ));

    // Gradients: 7x7 points over a square, mapped onto an octahedron.
    // The ring size 17*17 = 289 is close to a multiple of 49 (49*6 = 294)
    float n_ = 0.142857142857; // 1.0/7.0
    vec3  ns = n_ * D.wyz - D.xzx;

    vec4 j = p - 49.0 * floor(p * ns.z * ns.z);  //  mod(p,7*7)

    vec4 x_ = floor(j * ns.z);
    vec4 y_ = floor(j - 7.0 * x_ );    // mod(j,N)

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
    vec4 norm = _taylorInvSqrt(vec4(dot(p0,p0), dot(p1,p1), dot(p2, p2), dot(p3,p3)));
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
 
vec2 DistCombineUnion( const in vec2 v1, const in vec2 v2 )
{
	//if(v1.x < v2.x)
	//            return v1;
	//else
	return mix(v1, v2, step(v2.x, v1.x));
}
 
vec2 DistCombineIntersect( const in vec2 v1, const in vec2 v2 )
{
	return mix(v2, v1, step(v2.x,v1.x));
}
 
vec2 DistCombineSubtract( const in vec2 v1, const in vec2 v2 )
{
	return DistCombineIntersect(v1, vec2(-v2.x, v2.y));
}
 
float GetDistanceSphere( const in vec3 vPos, const in vec3 vSphereOrigin, const in float fSphereRadius )
{
	return length(vPos - vSphereOrigin) - fSphereRadius;
}
 
float GetDistancePlane( const in vec3 vPos, const in vec3 vPlaneNormal, const in float fPlaneDist )
{
	return dot(vPos, vPlaneNormal) + fPlaneDist ;
}

float GetBumpyFloorHeight(const in vec3 vPos)
{
	return ((sin((vPos.x + time) * 2.0)+sin(vPos.z + time * 7.0)) * 0.1 + 0.1);              
	 
}
 
float GetDistanceBumpyFloor( const in vec3 vPos, const in float fHeight )
{
	return vPos.y - fHeight + GetBumpyFloorHeight(vPos);
}
 
 
float sdSphere(vec3 p, float s) {
    return length(p) - s;
}

vec2 blend(vec2 d1, vec2 d2) {
    float dd = cos((d1.x - d2.x) * -0.2);
    return mix(d1, d2, dd);
}

vec2 GetDistanceScene( const in vec3 vPos )
{             
	vec2 vDistPlane1 = vec2(GetDistanceBumpyFloor( vPos, -1.0 ), 1.0);
                
	vec3 vSphere1Pos = vec3( 1.0 + sin(time), -0.3, cos(time));
        vSphere1Pos.y -= GetBumpyFloorHeight(vSphere1Pos);
        vec2 vDistSphere1 = vec2(GetDistanceSphere( vPos, vSphere1Pos, 0.75 ), 2.0);
	
        vec3 vSphere2Pos = vec3(-1.0 - sin(time), -0.3, cos(time));
        vSphere2Pos.y -= GetBumpyFloorHeight(vSphere2Pos);
        vec2 vDistSphere2 = vec2(GetDistanceSphere( vPos, vSphere2Pos, 0.75 ), 3.0);
               
        //vec2 vResult = DistCombineUnion(vDistSphere1, vDistSphere2);
        //vResult = DistCombineUnion(vDistPlane1, vResult);
	//vResult = min(min(blend(sphere1, torus), blend(sphere2, torus)), plane);
               
	float sphere1 = sdSphere(vSphere1Pos + vec3(cos(time * 0.2 + 3.14) * 0.45,0,0), 0.25);
        float sphere2 = sdSphere(vSphere2Pos + vec3(cos(time * 0.2) * 0.45,0,0), 0.25);
        
	//vec2 vResult = vec2(0,0);
	//vResult.x = (blend(sphere1, sphere2));
	
	vec2 vResult = ((blend(vDistSphere1, vDistSphere2)));
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
		vec2 rg = vec2(1.0);//gl_FragCoord.xy / resolution;
		vec2 vTile = step(fract(vec2(vPos.x + time, vPos.z)), vec2(0.5));
		float fBlend = mod(vTile.x + vTile.y, 2.0);
		//mat.cAlbedo = mix(vec3(1.0,0.1, 0.1), vec3(0.1,0.1, 1.0), fBlend);
		mat.cAlbedo = vec3(snoise( vec3(rg * 30.0, 1.0) ));
		mat.fSmoothness = 0.3;
		mat.fR0 = 0.01;
	}
	else
	{	
		mat.cAlbedo = vec3( mod(fObjId, 2.0), mod(fObjId / 2.0, 2.0), mod(fObjId/4.0, 2.0));
	}
	
	return mat;
}
 
vec3 GetSkyGradient( const in vec3 vDir )
{
	float fBlend = vDir.y * 0.5 + 0.5;
	return mix(vec3(0.8, 1.6, 2.0), vec3(0.1, 0.1, 2.0), fBlend);
}
 
vec3 GetLightPos()
{
	return vec3(5,5,0);//(sin(time), 1.5 + cos(time * 1.231), cos(time * 1.1254));
}
 
vec3 GetLightCol()
{
	return vec3(18.0, 18.0, 6.0);
}
 
vec3 GetAmbientLight(const in vec3 vNormal)
{
	return GetSkyGradient(vNormal);
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
 
vec3 GetSceneNormal( const in vec3 vPos )
{
	// tetrahedron normal  
	
	float fDelta = 0.01;
	
	vec3 vOffset1 = vec3( fDelta, -fDelta, -fDelta);
	vec3 vOffset2 = vec3(-fDelta, -fDelta,  fDelta);
	vec3 vOffset3 = vec3(-fDelta,  fDelta, -fDelta);
	vec3 vOffset4 = vec3( fDelta,  fDelta,  fDelta);
	
	float f1 = GetDistanceScene( vPos + vOffset1 ).x;
	float f2 = GetDistanceScene( vPos + vOffset2 ).x;
	float f3 = GetDistanceScene( vPos + vOffset3 ).x;
	float f4 = GetDistanceScene( vPos + vOffset4 ).x;
	
	vec3 vNormal = vOffset1 * f1 + vOffset2 * f2 + vOffset3 * f3 + vOffset4 * f4;
	
	return normalize( vNormal );
}

// This is an excellent resource on ray marching -> http://www.iquilezles.org/www/articles/distfunctions/distfunctions.htm
void Raymarch( const in C_Ray ray, out C_HitInfo result, const float fMaxDist, const int maxIter )
{            
	const float fEpsilon = 0.01;
	const float fStartDistance = 0.1;
	
	result.fDistance = fStartDistance; 
	result.fObjectId = 0.0;
		      
	for(int i=0;i<=128;i++)                  
	{
		result.vPos = ray.vOrigin + ray.vDir * result.fDistance;
		vec2 vSceneDist = GetDistanceScene( result.vPos );
		result.fObjectId = vSceneDist.y;
		
		// abs allows backward stepping - should only be necessary for non uniform distance functions
		if((abs(vSceneDist.x) <= fEpsilon) || (result.fDistance >= fMaxDist) || (i > maxIter))
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

float GetShadow( const in vec3 vPos, const in vec3 vLightDir, const in float fLightDistance )
{
	C_Ray shadowRay;
	shadowRay.vDir = vLightDir;
	shadowRay.vOrigin = vPos;
	
	C_HitInfo shadowIntersect;
	Raymarch(shadowRay, shadowIntersect, fLightDistance, 32);
				       
	return step(0.0, shadowIntersect.fDistance) * step(fLightDistance, shadowIntersect.fDistance );             
}

// http://en.wikipedia.org/wiki/Schlick's_approximation
float Schlick( const in vec3 vNormal, const in vec3 vView, const in float fR0, const in float fSmoothFactor)
{
	float fDot = dot(vNormal, -vView);
	fDot = min(max((1.0 - fDot), 0.0), 1.0);
	float fDot2 = fDot * fDot;
	float fDot5 = fDot2 * fDot2 * fDot;
	return fR0 + (1.0 - fR0) * fDot5 * fSmoothFactor;
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

vec3 GetObjectLighting(const in C_Ray ray, const in C_HitInfo intersection, const in C_Material material, const in vec3 vNormal, const in vec3 cReflection)
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
	
	vec3 vDiffuseReflection = material.cAlbedo * (vDiffuseLight + vAmbientLight);
	
	vec3 vSpecularReflection = cReflection * fAmbientOcclusion;
		       
	vSpecularReflection += GetBlinnPhongIntensity( ray, material, vLightDir, vNormal ) * vIncidentLight;
		       
	float fFresnel = Schlick(vNormal, ray.vDir, material.fR0, material.fSmoothness * 0.9 + 0.1);
	cScene = mix(vDiffuseReflection , vSpecularReflection, fFresnel);
	
	return cScene;
}

vec3 GetSceneColourSimple( const in C_Ray ray )
{
	C_HitInfo intersection;
	Raymarch(ray, intersection, 16.0, 32);
		       
	vec3 cScene;
	
	if(intersection.fObjectId < 0.5)
	{
		cScene = GetSkyGradient(ray.vDir);
	}
	else
	{
		C_Material material = GetObjectMaterial(intersection.fObjectId, intersection.vPos);
		vec3 vNormal = GetSceneNormal(intersection.vPos);
		
		// use sky gradient instead of reflection
		vec3 cReflection = 5.0 * GetSkyGradient(reflect(ray.vDir, vNormal));
		
		// apply lighting
		cScene = GetObjectLighting(ray, intersection, material, vNormal, cReflection );
	}
	
	ApplyAtmosphere(cScene, ray, intersection);
	
	return cScene;
}


vec3 GetSceneColour( const in C_Ray ray )
{                                                             
	C_HitInfo intersection;
	Raymarch(ray, intersection, 30.0, 256);
		       
	vec3 cScene;
	
	if(intersection.fObjectId < 0.5)
	{
		cScene = GetSkyGradient(ray.vDir);
	}
	else
	{
		C_Material material = GetObjectMaterial(intersection.fObjectId, intersection.vPos);
		vec3 vNormal = GetSceneNormal(intersection.vPos);
		
		vec3 cReflection;
		//if((material.fSmoothness + material.fR0) < 0.01)
		//{
		//	// use sky gradient instead of reflection
		//	vec3 cReflection = GetSkyGradient(reflect(ray.vDir, vNormal));			
		//}
		//else
		{
			// get colour from reflected ray
			float fSepration = 0.05;
			C_Ray reflectRay;
			reflectRay.vDir = reflect(ray.vDir, vNormal);
			reflectRay.vOrigin = intersection.vPos + reflectRay.vDir * fSepration;
					
			cReflection = GetSceneColourSimple(reflectRay);                                                 		
		}
		
		// apply lighting
		cScene = GetObjectLighting(ray, intersection, material, vNormal, cReflection );
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
	
	GetCameraRayLookat( OrbitPoint(-mouse.x * 5.0, mouse.y) * 5.0, vec3(0.0, 0.0, 0.0), ray);
	//GetCameraRayLookat(vec3(0.0, 0.0, -5.0), vec3(0.0, 0.0, 0.0), ray);
	
	vec3 cScene = GetSceneColour( ray );
	
	float fExposure = 1.5;
	gl_FragColor = vec4( Tonemap(cScene * fExposure), 1.0 );
}