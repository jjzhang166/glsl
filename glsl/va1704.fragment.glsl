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
	vec2 vPixel1=gl_FragCoord.xy;

	vec2 vScreen=resolution;
	vec2 vMouse=vec2(0.1,0.1)+mouse;

	float fTime=time*0.5;

	vec2 vPixel2=-1.0+2.0*vPixel1/vScreen;

	float n0=dot(vPixel2,vPixel2);
	float n1=atan(vPixel2.y,vPixel2.x);
	float n2=sqrt(n0);

	vec2 vPixel3=vec2(
		0.5*fTime+0.1/n2,
		n1/2.0)/0.01;

	vec3 v=vec3(
		vPixel3.x+vPixel3.y+cos(sin(fTime)*2.0)*100.0+sin(vPixel3.x/10.0)*100.0,
		vPixel3.y/vScreen.y/(vMouse.x*100.0)+fTime,
		vPixel3.x/vScreen.x/(vMouse.y*100.0));

	float r=abs(sin(v.y+fTime)/2.0+v.z/2.0-v.y-v.z+fTime);
	float g=abs(sin(r+sin(v.x/50.0+fTime)+sin(vPixel3.y/50.0+fTime)+sin((vPixel3.x+vPixel3.y)/10.0)*1.0));
	float b=abs(sin(g+cos(v.y+v.z+g)+cos(v.z)+sin(v.x/100.0)));

	vec3 c=vec3(r,g,b)*lines(vMouse.x*0.3,resolution.y*0.1,vMouse.xyx,vPixel1,fTime);
	if(n0>1.0) c=mix(c,vec3(0.0),(1.0-n0)*10.5);

	gl_FragColor=vec4((1.0-c)*n2,1.0);
}