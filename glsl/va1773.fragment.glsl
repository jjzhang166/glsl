// Lens flare
// the.savage@hotmail.co.uk

#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform vec2 mouse;

uniform float time;

//

const vec3 cBackground1=vec3(0.1,0.5,0.8);
const vec3 cBackground2=vec3(0.6,0.2,0.0);
const vec3 cAmbient=vec3(0.1,0.1,0.1);
const vec3 cSun=vec3(1.0,1.0,0.0);
const vec3 cFlare=vec3(0.2,0.3,0.8);

const float fBackground=0.008;
const float fAmbient=0.0;
const float fDiffuse=1.0;
const float fSunSize=1500.0;
const float fSunOpacity=0.8;
const float fFlareSize=500.0;
const float fFlareOpacity=0.4;
const float fExposure=1.0;
const float fThreshold=0.0;
const float fAmplify=1.0;

//
//

float getSun(const vec2 vPoint,const vec3 vLight,const float fSize,const float fOpacity)
{
	float fDist=length(vPoint-vLight.xy);
	return clamp((1.0/(fDist*fDist))*fSize,0.0,1.0)*fOpacity;
}

//
//

float getFlare(const vec2 vPoint,const vec3 vLight,const float fPosition,const float fSize,const float fOpacity)
{
	vec2 vScreen=resolution;

	if(vLight.x<0.0 || vLight.x>vScreen.x ||
		vLight.y<0.0 || vLight.y>vScreen.y)
		return 0.0;

	vec2 vFlare=(vScreen-vLight.xy);
	vec2 vDir=normalize(vLight.xy-vFlare);

	float fLen=length(vLight.xy-vFlare);
	vFlare+=vDir*fLen*fPosition;

	float fStrength=(1.0-(fLen/(min(vScreen.x,vScreen.y)*2.0)))*fOpacity;
	float fDist=length(vPoint-vFlare);

	return clamp((1.0/(fDist*fDist))*fSize,0.0,1.0)*fStrength;
}

//
//

vec3 getBackground(const vec2 vPoint)
{
	return mix(cBackground2,cBackground1,clamp(vPoint.y*fBackground,0.0,1.0));
}

//
//

vec3 getColour(const vec2 vPoint)
{
	vec2 vScreen=resolution;
	vec2 vMouse=(mouse*(vScreen*2.0))-(vScreen/2.0);

	vec3 vLight=vec3(vMouse,100.0);
	vec3 cDiffuse=getBackground(vPoint);

	float fSun=getSun(vPoint,vLight,fSunSize,fSunOpacity);

	float fFlare=(
		getFlare(vPoint,vLight,0.0,fFlareSize*0.1,fFlareOpacity*1.5)+
		getFlare(vPoint,vLight,0.1,fFlareSize*0.5,fFlareOpacity)+
		getFlare(vPoint,vLight,0.3,fFlareSize,fFlareOpacity*1.5)+
		getFlare(vPoint,vLight,0.65,fFlareSize*0.1,fFlareOpacity*1.6)+
		getFlare(vPoint,vLight,0.7,fFlareSize*0.2,fFlareOpacity)+
		getFlare(vPoint,vLight,0.8,fFlareSize*2.5,fFlareOpacity*1.4)+
		getFlare(vPoint,vLight,0.9,fFlareSize*0.3,fFlareOpacity*1.5));

	return (cAmbient*fAmbient)+(cDiffuse*fDiffuse)+(cSun*fSun)+(cFlare*fFlare);
}

//
//

vec3 getExposure(const vec3 cColour,const float fExposure)
{
//	return cColour*pow(2.0,fExposure);
	return 1.0-exp(-cColour*fExposure);
}

//
//

vec3 getThreshold(const vec3 cColour,const float fThreshold,const float fAmplify)
{
	if(fThreshold!=0.0)
	{
		if(fAmplify==1.0)
			return (cColour-fThreshold)/(1.0-fThreshold);

		const vec3 cLum=vec3(0.30,0.59,0.11);
		float fLum=dot(cColour,cLum);

		if(fLum<fThreshold) return cColour;
	}
	return cColour*fAmplify;
}

//
//

void main(void)
{
	vec2 vPoint=gl_FragCoord.xy;
	vec3 cColour=getColour(vPoint);

//	cColour=getExposure(cColour,fExposure);
//	cColour=getThreshold(cColour,fThreshold,fAmplify);

	gl_FragColor=vec4(cColour,1.0);
}
