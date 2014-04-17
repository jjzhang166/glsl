/* wzl was here, forking, not knowing what he is doing
 * making your eyes cum since 2008
 *
 * http://wzl.vg/
 * http://trbl.at/
 */

#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform float time;

//Object A (tunnel)
float oa(vec3 q)
{
 return 2.0 - (sin(q.x+sin(1.0 + q.z)) + cos(q.x) + sin(3.0 + q.y)) * 0.69;
}



//Scene
float o(vec3 q)
{
 return min(oa(q),(sin(time)+ 1.5) * 4.0);
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
 
 vec4 c=vec4(1.0);
 vec3 org=vec3(sin(time)*.5,cos(time*.5)*.25+.25,time)+time,dir=normalize(vec3(p.x*1.6 + sin(time),p.y * 1.6 + cos(time),1.0)),q=org,pp;
 float d=.0;

 float limit = 4.0 + (sin(time * 2.0) + 1.0) * 48.0;
 //First raymarching
 for(int i=0;i<128;i++)
 {
	 if(i >= int(limit))
		 continue;
  d=o(q);
  q+=d*dir;
 }
 pp=q;
 float f=length(q-org)*0.0052;

 //Second raymarching (reflection)
 dir=reflect(dir,gn(q));
 q+=dir;
 for(int i=0;i<0;i++)
 {
 d=o(q);
 q+=d*dir;
 }
 c=max(dot(gn(q),vec3(.01,.01,.0)),.0)+vec4(.03,cos(time*.5)*.5+.5,sin(time*.5)*.5+.5,1.)*min(length(q-org)*.004,1.);

 //Ribbon Color
 

 //Final Color
 vec4 fcolor = ((c+vec4(f))+(1.-min(pp.y+1.9,1.))*vec4(1.,.8,.7,.5))*min(time*.5,1.);
 gl_FragColor=vec4(fcolor.xyz,1.0);
}