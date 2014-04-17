// Started from some code that was already here without comments.
// note: the final step of raymarching is using 'false position' method.
// - Dmytry.

#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform float time;

vec3 org;


float o(vec3 q)
{
 //q+=vec3(0.5);
 vec3 r=q-floor(q)-vec3(0.5);
 //float angle=2.0*floor(q.x);
 //mat2 rot=mat2(cos(angle), sin(angle), -sin(angle), cos(angle));
 //r.xy=r.xy*rot;
 return length(r*vec3(1,1,2)+vec3(0,-abs(r.x),0))-0.2-0.1*sin(time*10.0+dot(floor(q),vec3(2,0.4,0.2)));//oa(q)+fbm(q.xy);
}

//Get Normal
vec3 gn(vec3 q)
{
 vec3 f=vec3(.01,0,0);
 float b=o(q);
 return normalize(vec3(o(q+f.xyy)-b,o(q+f.yxy)-b,o(q+f.yyx)-b));
}

//MainLoop
void main(void)
{
 vec2 p = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
 p.x *= resolution.x/resolution.y;
 
 vec4 c=vec4(1.0);
 org=vec3(sin(0.2*time),sin(0.5*time),time);
 vec3 dir=normalize(vec3(p.x,p.y,1.5));
 vec3 q=org;
 vec3 pp;

 float d=.0;
 float old_d=d;
 float dist=0.0;

 //First raymarching
	const float step_scaling=0.4;
 const float extra_step=0.03;
 for(int i=0;i<64;i++)
 {
   old_d=d;
   d=o(q)*step_scaling;
   if(d<0.0){
     dist-=(old_d+extra_step)*(1.0-old_d/(old_d-d));
	 
     q=org+dist*dir;
     vec3 n=gn(q);
     gl_FragColor=vec4((sin(n*15.0)+vec3(1))*0.5,1.0);
     break;
   }
  dist+=d+extra_step; 
  q=org+dist*dir;
 }
 
}