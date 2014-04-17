// the.savage@hotmail.co.uk

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;
uniform vec2 mouse;

uniform float time;

float rand(const vec2 vSeed)
{
	const vec2 vRand=vec2(12.9898,78.233);
	const float fRand=43758.5453;

	return fract(sin(dot(vSeed,vRand))*fRand);
}

vec3 lines(const float fStrength,const float fDensity,const vec3 cColour,const vec2 vPixel,const float fTime)
{
	const vec3 cLumin=vec3(0.21,0.72,0.07);

	vec3 vRand=vec3(
		rand(vPixel+fTime+1.0),
		rand(vPixel+fTime+2.0),
		rand(vPixel+fTime+3.0));

	float fCount=resolution.y;

	float fSin=sin(vPixel.y*fDensity);
	float fCos=cos(vPixel.y*fDensity);

	return cColour+vec3(dot(vec3(fSin,fCos,fSin)*vRand*fStrength,cLumin));
}

void main(void)
{
	vec2 vPixel=gl_FragCoord.xy;

	vec2 vScreen=resolution;
	vec2 vMouse=vec2(0.1,0.1)+mouse;

	float fTime=time*0.5;

	vec3 v=vec3(
		vPixel.x+vPixel.y+cos(sin(fTime)*2.0)*100.0+sin(vPixel.x/100.0)*100.0,
		vPixel.y/vScreen.y/(vMouse.x*5.0)+fTime,
		vPixel.x/vScreen.x/(vMouse.y*5.0));

	float r=abs(sin(v.y+fTime)/2.0+v.z/2.0-v.y-v.z+fTime);
	float g=abs(sin(r+sin(v.x/50.0+fTime)+sin(vPixel.y/50.0+fTime)+sin((vPixel.x+vPixel.y)/10.0)*1.0));
	float b=abs(sin(g+cos(v.y+v.z+g)+cos(v.z)+sin(v.x/100.0)));

	gl_FragColor=vec4(vec3(r,g,b)*lines(0.3,resolution.y*0.1,vec3(0.8,1.0,0.4),vPixel,fTime),1.0);
}