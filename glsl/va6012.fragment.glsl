#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform float time;

//Object A (tunnel)
float oa(vec3 q)
{
 return cos(q.x)+cos(q.y*.0)+sin(q.z)+sin(q.y*50.5)*-.01;	// this math generates the model/form
}



//Scene
float o(vec3 q)
{
 return min(oa(q),5.);
}

//Get Normal
vec3 gn(vec3 q)
{
 vec3 f=vec3(.02,.01,.25);
 return normalize(vec3(o(q+f.yxx),o(q+f.xxy),o(q+f.xxx)));
}

//MainLoop
void main(void)
{
 vec2 p = -1.5 + 2.6 * gl_FragCoord.xy / resolution.xy;
 p.x *= resolution.x/resolution.y;
 
 vec4 c=vec4(1.0);
 vec3 org=vec3(sin(time)*.5,sin(time*1.3)*1.25+.25,time),dir=normalize(vec3(p.x*1.6,p.y,2.)),q=org,pp;
 float d=.0;

 //First raymarching
 for(int i=0;i<64;i++)
 {
  d=o(q);
  q+=d*dir;
 }
 pp=q;
 float f=length(q-org)*0.002;

 //Second raymarching (reflection)
 dir=reflect(dir,gn(q));
 q+=dir;
 for(int i=0;i<64;i++)
 {
 d=o(q);
 q+=d*dir;
 }
 c=max(dot(gn(q),vec3(.5,.1,.0)),.0)+vec4(3.3,pow(sin(time*.5), 0.2)*.5+.5,pow(sin(time*.3),3.0)*0.5+.5,10.)*min(length(q-org)*.004,1.);

 //Ribbon Color
 

 //Final Color
 vec4 fcolor = ((c+vec4(f))+(1.-min(pow(pp.y, .31)+.5,1.4))*vec4(3.1,.8,.81,1.))*min(time*.2,10.8);
 gl_FragColor=vec4(fcolor.xyz,1.);
}