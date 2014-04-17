#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform float time;

//Object A (tunnel)
float oa(vec3 q)
{
 
 return cos(q.x)+cos(q.y*1.5)+cos(q.z)+cos(q.y*20.)*.05;
}

//Scene
float o(vec3 q)
{
 return oa(q);
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
	float aspect = resolution.x/resolution.y;
 vec2 p = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
 p.x *= aspect;
 
 vec4 c=vec4(1.0);
	
	float dd = sin(time*0.125)*6.3;
	float ox = 0.0; // sin(time);
	float oy = 0.0; // sin(time)*0.5; // *.5+.5;
	float oz = time+dd; // time; // cos(time)*2.5; // time
 vec3 org=vec3(ox,oy,oz);
	
	
	float dx = p.x*aspect + dd;
	float dy = p.y; // sin(time)*0.5; // *.5+.5;
	float dz = 1.0; // time; // cos(time)*2.5; // time
	
	vec3 dir=normalize(vec3(dx,dy,dz));
	vec3 q=org;
	vec3 pp;
	

 float d=.0;

 //First raymarching
 for(int i=0;i<34;i++)
 {
  d=o(q);
  q+=d*dir;
 }
 pp=q*0.0;

/*
 //Second raymarching (reflection)
 dir=reflect(dir,gn(q));
 q+=dir;
 for(int i=0;i<34;i++)
 {
 d=o(q);
 q+=d*dir;
 }
*/
	
	
 c=max(dot(gn(q),vec3(.1,.1,.0)),.0)+vec4(.3,cos(time*.5)*.5+.5,sin(time*.5)*.5+.5,1.)*min(length(q-org)*.04,1.);


 //Final Color
 vec4 fcolor = ((c)+(1.-min(pp.y+1.9,1.))*vec4(1.,.8,.7,1.))*min(time*.5,1.);
 gl_FragColor=vec4(fcolor.xyz,1.0);
}