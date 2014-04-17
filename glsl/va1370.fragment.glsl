// []_[]

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;
uniform vec2 mouse;
uniform float time;

//Object A (tunnel)
float oa(vec3 q)
{
 return cos(q.x)*sin(q.x)*atan(q.x)+cos(q.y*1.5)*atan(q.z)+cos(q.z)+cos(q.y*20.)*.05;
}

//Object B (ribbon)
float ob(vec3 q)
{
 return length(max(abs(q-vec3(cos(q.z*1.5)*.3,-.5+cos(q.z)*.2,.0))-vec3(.125,.02,time+3.),vec3(.0)));
}

//Scene
float o(vec3 q)
{
 return min(oa(q),ob(q));
}

//Get Normal
vec3 gn(vec3 q)
{
 vec3 f=vec3(.01,0,0);
 return normalize(vec3(o(q+f.xyy),o(q+f.yxy),o(q+f.yyx)));
}

//MainLoop
void main(void)
{
 vec2 p = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
 p.x *= resolution.x/resolution.y;
 
 vec3 org=vec3(sin(time)*.5,cos(time*.5)*.25+.25,time);
 vec2 di = vec2(p.x*1.6,p.y-0.8)+vec2(mouse.x*4.-2.,mouse.y*1.5)*2.;
 vec3 dir=normalize(vec3(di.xy,1.0));
 vec3 q=org;
 vec3 pp;
 float d=.0;

 //First raymarching
int aaa = int((3.+cos(time))*3.)*0+1;
if (aaa > 2)	{	d=o(q); q+=d*dir;	d=o(q); q+=d*dir;	}
if (aaa > 3)	{	d=o(q); q+=d*dir;	d=o(q); q+=d*dir;	}
if (aaa > 4)	{	d=o(q); q+=d*dir;	d=o(q); q+=d*dir;	}
if (aaa > 5)	{	d=o(q); q+=d*dir;	d=o(q); q+=d*dir;	}
if (aaa > 6)	{	d=o(q); q+=d*dir;	d=o(q); q+=d*dir;	}
if (aaa > 7)	{	d=o(q); q+=d*dir;	d=o(q); q+=d*dir;	}
if (aaa > 8)	{	d=o(q); q+=d*dir;	d=o(q); q+=d*dir;	}
if (aaa > 9)	{	d=o(q); q+=d*dir;	d=o(q); q+=d*dir;	}
if (aaa > 10)	{	d=o(q); q+=d*dir;	d=o(q); q+=d*dir;	}
{	d=o(q); q+=d*dir;	d=o(q); q+=d*dir;	}
	{	d=o(q); q+=d*dir;	d=o(q); q+=d*dir;	}
	{	d=o(q); q+=d*dir;	d=o(q); q+=d*dir;	}
	
 for(int i=0;i<1;i++)
 {
 d=o(q);
 q+=d*dir;
 }
	
 pp=q;
 float f=length(q-org)*0.02;

 //Second raymarching (reflection)
 dir=refract(dir,gn(q), (1.+sin(time))/2.);
 q+=dir;
 for(int i=0;i<12;i++)
 {
 d=o(q);
 q+=d*dir;
 }
 vec4 c=max(dot(gn(q),vec3(.1,.1,.0)),.0)+vec4(.3,cos(time*.5)*.5+.5,sin(time*.5)*.5+.5,1.)*min(length(q-org)*.04,1.);

 //Ribbon Color
 if(oa(pp)>ob(pp))c=mix(c,vec4(cos(time*.3)*.5+.5,cos(time*.2)*.5+.5,sin(time*.3)*.5+.5,1.),.3);

 //Final Color
 vec4 fcolor = ((c+vec4(f))+(1.-min(pp.y+1.9,1.))*vec4(1.,.8,.7,1.))*min(time*0.5,1.);
 gl_FragColor=vec4(fcolor.xyz,1.0);
}