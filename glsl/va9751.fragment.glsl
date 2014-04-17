#ifdef GL_ES
precision mediump float;
#endif

/** jhejl animating spots */

uniform vec2 resolution;
uniform vec2 mouse;
uniform float time;

#define PI 3.1416

#define BlendLinearDodgef 			BlendAddf
#define BlendLinearBurnf 			BlendSubstractf
#define BlendAddf(base, blend) 		min(base + blend, 1.0)
#define BlendSubstractf(base, blend) 	max(base + blend - 1.0, 0.0)
#define BlendLightenf(base, blend) 		max(blend, base)
#define BlendDarkenf(base, blend) 		min(blend, base)
#define BlendLinearLightf(base, blend) 	(blend < 0.5 ? BlendLinearBurnf(base, (2.0 * blend)) : BlendLinearDodgef(base, (2.0 * (blend - 0.5))))
#define BlendScreenf(base, blend) 		(1.0 - ((1.0 - base) * (1.0 - blend)))
#define BlendOverlayf(base, blend) 	(base < 0.5 ? (2.0 * base * blend) : (1.0 - 2.0 * (1.0 - base) * (1.0 - blend)))
#define BlendSoftLightf(base, blend) 	((blend < 0.5) ? (2.0 * base * blend + base * base * (1.0 - 2.0 * blend)) : (sqrt(base) * (2.0 * blend - 1.0) + 2.0 * base * (1.0 - blend)))
#define BlendColorDodgef(base, blend) 	((blend == 1.0) ? blend : min(base / (1.0 - blend), 1.0))
#define BlendColorBurnf(base, blend) 	((blend == 0.0) ? blend : max((1.0 - ((1.0 - base) / blend)), 0.0))
#define BlendVividLightf(base, blend) 	((blend < 0.5) ? BlendColorBurnf(base, (2.0 * blend)) : BlendColorDodgef(base, (2.0 * (blend - 0.5))))
#define BlendPinLightf(base, blend) 	((blend < 0.5) ? BlendDarkenf(base, (2.0 * blend)) : BlendLightenf(base, (2.0 *(blend - 0.5))))
#define BlendHardMixf(base, blend) 	((BlendVividLightf(base, blend) < 0.5) ? 0.0 : 1.0)
#define BlendReflectf(base, blend) 		((blend == 1.0) ? blend : min(base * base / (1.0 - blend), 1.0))

/*
** Vector3 blending modes
*/

// Component wise blending
#define Blend(base, blend, funcf) 		vec3(funcf(base.r, blend.r), funcf(base.g, blend.g), funcf(base.b, blend.b))

#define BlendNormal(base, blend) 		(blend)
#define BlendLighten				BlendLightenf
#define BlendDarken				BlendDarkenf
#define BlendMultiply(base, blend) 		(base * blend)
#define BlendAverage(base, blend) 		((base + blend) / 2.0)
#define BlendAdd(base, blend) 		min(base + blend, vec3(1.0))
#define BlendSubstract(base, blend) 	max(base + blend - vec3(1.0), vec3(0.0))
#define BlendDifference(base, blend) 	abs(base - blend)
#define BlendNegation(base, blend) 	(vec3(1.0) - abs(vec3(1.0) - base - blend))
#define BlendExclusion(base, blend) 	(base + blend - 2.0 * base * blend)
#define BlendScreen(base, blend) 		Blend(base, blend, BlendScreenf)
#define BlendOverlay(base, blend) 		Blend(base, blend, BlendOverlayf)
#define BlendSoftLight(base, blend) 	Blend(base, blend, BlendSoftLightf)
#define BlendHardLight(base, blend) 	BlendOverlay(blend, base)
#define BlendColorDodge(base, blend) 	Blend(base, blend, BlendColorDodgef)
#define BlendColorBurn(base, blend) 	Blend(base, blend, BlendColorBurnf)
#define BlendLinearDodge			BlendAdd
#define BlendLinearBurn			BlendSubstract
// Linear Light is another contrast-increasing mode
// If the blend color is darker than midgray, Linear Light darkens the image by decreasing the brightness. If the blend color is lighter than midgray, the result is a brighter image due to increased brightness.
#define BlendLinearLight(base, blend) 	Blend(base, blend, BlendLinearLightf)
#define BlendVividLight(base, blend) 	Blend(base, blend, BlendVividLightf)
#define BlendPinLight(base, blend) 		Blend(base, blend, BlendPinLightf)
#define BlendHardMix(base, blend) 		Blend(base, blend, BlendHardMixf)
#define BlendReflect(base, blend) 		Blend(base, blend, BlendReflectf)
#define BlendGlow(base, blend) 		BlendReflect(blend, base)
#define BlendPhoenix(base, blend) 		(min(base, blend) - max(base, blend) + vec3(1.0))
#define BlendOpacity(base, blend, F, O) 	(F(base, blend) * O + blend * (1.0 - O))

float smooth(float a, float b, float x)
{
    float t = clamp((x - a) / (b - a), 0.0, 1.0);
    return t * t * (3.0 - 2.0 * t);
}

vec3 GammaExpand(vec3 c)
{ 
    const float sRGBExp = 2.2;
    return vec3(pow(c.x,sRGBExp),pow(c.y,sRGBExp),pow(c.z,sRGBExp));
}

vec3 GammaCompress(vec3 c)
{ 
    const float sRGBExp = .4545;
    return vec3(pow(c.x,sRGBExp),pow(c.y,sRGBExp),pow(c.z,sRGBExp));
}

const vec3 lightColor = vec3(0.3, 0.45, 0.65);
vec2 lightArray[2];

vec3 fade(vec3 t) 
{
  return t*t*t*(t*(t*6.0-15.0)+10.0);
}

float cosInterp(float t)
{
    t = 0.5 - 0.5 * cos( t * 3.14159265 );
    return (t);
}

mat2 buildRotation2D(float a)
{
    mat2 m;
    m[0][0] = cos(a); m[0][1] = -sin(a);
    m[1][0] = sin(a); m[1][1] =  cos(a);	
    return (m);
}
 
float sdSphere( vec2 p, float s )
{
   return length(p)-s;
}

void main(void)
{
	mat2 m;
	m = buildRotation2D(time*.1);
	lightArray[0] = vec2(.8,.7);
	
        m = buildRotation2D(time*.23);
	lightArray[1] = vec2(.2,.8);
	
	vec2 p = (gl_FragCoord.xy) / resolution.xy;
	
	vec3 sumColor = vec3(0);//mix(vec3(0.15,0.05,0.0),vec3(.2,.1,.3),p.y);
	
	for (int i=0; i<2; i++)
	{
		float f = cos(1.-float(i+1));
		
		vec2 vRay  = lightArray[i]-p;	   			// ray: H to light
		float dRay = sqrt(dot(vRay,vRay)); 			// H to light magnitude
		vec2 nRay  = (vRay/dRay);	   			// normalize H to light
		
		// build light target (spot 'look at')
		float interp = cosInterp((f + time)*.2);		// smooth interp factor t
		float fOffset = mix(-.15,.15,interp);			// build offset
		vec2 vLookAt = vec2(.4,.4) + vec2(fOffset,-fOffset);	// apply offset
		
		// light dir
		vec2 dir = (lightArray[i]-vLookAt);			// ray to look-at pt
		dir = normalize(dir);
		
		// generate some light
		float shadow = 1. + exp(1.-dRay);
		
		// build falloff weights
		vec4 vWeight = vec4(1.);
		vWeight.yzw *= dRay;
		vWeight.zw  *= dRay;
		vWeight.w   *= dRay;
		
		// attenuation
		vec4 attenuation = vec4(.2,1.1,3.2,9.6);	// weights
		shadow *= 1. / dot(attenuation.xyzw,vWeight);   // dot with (1,d,d^2,d^3)
	
		float cosO = 2.69;//cos(radians(1.0)) == cos(0.017453) == 0.99984
		float cosI = 0.47;//cos(radians(25.0)); // cos(0.436332) == 0.906307
		float cosD = pow(dot(nRay, dir.xy),6.4);
	
		// cone
		vec3 eval = smooth(cosI, cosO, cosD) * shadow * lightColor;
		eval = fade(eval*1.8);
		eval = GammaCompress(eval);
		
		sumColor += BlendScreen(BlendScreen(sumColor,eval),BlendSoftLight(eval,eval));
	}
	sumColor.rgb = GammaCompress(sumColor.rgb);
	gl_FragColor = vec4(vec3(sumColor), 1.0);
}

  