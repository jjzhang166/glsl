#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float t=0.2*1500.0;

vec3 l=vec3(0.1,0.1,-0.5);
float rand2(vec2 co)
{
	return fract(sin(dot(co.xy,vec2(12.9898,78.233)))*43758.5453);
}
float smoothnoise(vec2 p,float scale)
{
	float s=1.0/scale;
	float a=rand2(floor(p*s));
	float b=rand2(floor(p*s)+vec2(1.0,0.0));
	float c=rand2(floor(p*s)+vec2(0.0,1.0));
	float d=rand2(floor(p*s)+vec2(1.0,1.0));
	float mx=smoothstep(0.0,1.0,(fract(p.x*s)));
	float my=smoothstep(0.0,1.0,(fract(p.y*s)));
	float m=length(fract(p*s));
	float x1=mix(a,b,mx);
	float x2=mix(c,d,mx);
	return mix(x1,x2,my);
}
float getHeight(vec2 p)
{
	float cl=smoothnoise(p+t*2.0,64.0)*128.0;
	cl+=smoothnoise(p+t*0.75,16.0)*62.0;
	cl+=smoothnoise(p+t*0.3,8.0)*30.0;
	cl+=smoothnoise(p+t*0.05,1.5)*1.5;
	return cl*sin(time)*(cos(time)-p.y*0.003)*0.33;
}
float fTerH(float x,float z)
{
	return getHeight(vec2(x,z));
}
vec3 castRay(vec3 ro,vec3 rd)
{
	float a,b,c=.25;
	float t = 0.0;
	for(int j = 0; j < 9999; j++)
	{
		t += c;
		if (t >= 25.0) break;
		c+=.06;vec3 p=ro+rd*t;
		float h=fTerH(p.x,p.z);
		if(p.y<h)
		{
			a=t-c;
			b=t;
			for (int i=0;i<9999;i++)
			{
				if (i >= int(9.0-c*2.0)) break;
				t=(a+b)*.5;
				p=ro+rd*t;
				h=fTerH(p.x,p.z);
				if(p.y<h)
					b=t;
				else
					a=t;
			}
			return p;
		}
	}
	return vec3(-500.0,0.0,0.0);
}
vec3 getNormal(vec3 p)
{
	float eps=0.009;
	vec3 n=vec3(fTerH(p.x-eps,p.z)-fTerH(p.x+eps,p.z),1.5*eps,fTerH(p.x,p.z-eps)-fTerH(p.x,p.z+eps));
	return normalize(n);
}
vec3 getColour(vec3 p,vec3 n)
{
	float d=max(0.0,dot(n,l));
	d=(d*0.75)+0.25*2.0;
	vec3 r=reflect(n,-l);
	vec3 spec=vec3(pow(max(0.0,dot(n,r)),250.0));
	float c=smoothnoise(p.xz+p.yy,4.0)*d;
	return vec3(0.01,c*0.25+0.1,c*0.4+0.1)+spec*vec3(1.0,0.86,0.7);
}
void main()
{
	vec3 c;
	vec3 vCamPos = vec3(sin(-time * 0.25) * 10.0, 4.0 + abs(cos(time * 0.5) * 2.8), cos(-time * 0.25) * 10.0);
	vec2 vViewPlane = ((gl_FragCoord.xy / resolution.xy * 2.0) - 1.0) / vec2(1.0, resolution.x / resolution.y);
	vec3 vForwards = normalize(vec3(1.0, sin(time) * 2.0, 1.0) - vCamPos);
	vec3 vRight = normalize(cross(vForwards, vec3(0.0, 1.0, 0.0)));
	vec3 vUp = cross(vRight, vForwards);
	vec3 dir = normalize((-vRight * vViewPlane.x) + (vUp * vViewPlane.y) + vForwards);
	vec3 p=castRay(vCamPos*14.0,dir*14.0);
	if(p.x>-500.0)
	{
		vec3 n=getNormal(p);
		c=getColour(p,n)*(2.0-p.z*0.008);
	}
	else
	{
		c=vec3(0.0,0.0,0.0);
	}
	gl_FragColor=vec4(c,1.0);
}
