#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 l=vec3(0.1,0.5,-0.5);
float time1 = time * 10.0;
float rand2(vec2 co) {return fract(sin(dot(co.xy,vec2(12.9898,78.233)))*43758.5453);}

float smoothnoise(vec2 p,float scale) {
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
float getHeight(vec2 p) {
	float cl=smoothnoise(p+time1*2.0,64.0)*128.0;
	cl+=smoothnoise(p+time1*0.75,16.0)*62.0;
	cl+=smoothnoise(p+time1*0.3,8.0)*30.0;
	cl+=smoothnoise(p+time1*0.05,1.5)*1.5;
	return cl*(1.0-p.y*0.003)*0.25;
}

vec3 castRay(vec3 ro,vec3 rd)
{
	float a,b,c=.25;
	for(float t=0.;t<25.0;t+=.25)
	{
		c+=.06;vec3 p=ro+rd*t;
		float h=getHeight(vec2(p.x,p.z));
		if(p.y<h)
		{
			a=t-c;
			b=t;
			for (int i=0;i<9;i++)
			{
				float t1=(a+b)*.5;
				p=ro+rd*t1;
				h=h=getHeight(vec2(p.x,p.z));
				if(p.y<h)
					b=t1;
				else
					a=t1;
			}
			return p;
		}
	}
	return vec3(-500.0,0.0,0.0);
}
vec3 getNormal(vec3 p)
{
	float eps=0.009;
	vec3 n=vec3(getHeight(vec2(p.x-eps,p.z))-getHeight(vec2(p.x+eps,p.z)),1.5*eps,getHeight(vec2(p.x,p.z-eps))-getHeight(vec2(p.x,p.z+eps)));
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

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;
	vec3 org = vec3(0,3.6,0);
	vec3 dir = normalize(vec3(position,-5.));
	
	vec3 c;
	vec3 p=castRay(org*14.0,dir*14.0);
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