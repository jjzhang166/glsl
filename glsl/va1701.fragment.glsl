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

void main(void)
{
	vec2 vPixel=gl_FragCoord.xy;

	vec2 vScreen=resolution;
	vec2 vMouse=vec2(0.1,0.1)+mouse;

	float fTime=time*(vMouse.x*10.0);

	float s1=(rand(vMouse+0.0)*2.0)-1.0;
	float s2=(rand(vMouse+1.0)*2.0)-1.0;
	float s3=(rand(vMouse+2.0)*2.0)-1.0;

	float n1=rand(vMouse+3.0);
	float n2=rand(vMouse+4.0);
	float n3=rand(vMouse+5.0);

	vec2 b1=vec2(cos(fTime*s1)*n1,sin(fTime*s1)*n1);
	vec2 b2=vec2(cos(fTime*s2)*n2,sin(fTime*s2)*n2);
	vec2 b3=vec2(cos(fTime*s3)*n3,sin(fTime*s3)*n3);

	vec2 p=(-1.0+2.0*vPixel/vScreen)*(vMouse.y*5.0);

	float r1=(dot(p+b1,p+b1))*4.0;
	float r2=(dot(p+b2,p+b2))*10.0;
	float r3=(dot(p+b3,p+b3))*8.0;

	float m1=1.0/r1;
	float m2=1.0/r2;
	float m3=1.0/r3;

	float c=pow(m1+m2+m3,8.0);

	gl_FragColor=1.0-vec4(vec3(n1,n2,n3)*c,1.0);
}
