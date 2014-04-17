// Black and White Cubes and Spheres using AA and DOF
// Using the backbuffer for acumulation
//
// The old stuff this time with DOF
//
// Very pretty at 0.5 :)
//
// by @paulofalcao
//

#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;
uniform sampler2D backbuffer;

//Util Start
float PI=3.14159265;

vec2 ObjUnion(
  in vec2 obj0,
  in vec2 obj1)
{
  if (obj0.x<obj1.x)
    return obj0;
  else
    return obj1;
}

vec2 sim2d(
  in vec2 p,
  in float s)
{
   vec2 ret=p;
   ret=p+s/2.0;
   ret=fract(ret/s)*s-s/2.0;
   return ret;
}

vec3 stepspace(
  in vec3 p,
  in float s)
{
  return p-mod(p-s/2.0,s);
}

vec3 phong(
  in vec3 pt,
  in vec3 prp,
  in vec3 normal,
  in vec3 light,
  in vec3 color,
  in float spec,
  in vec3 ambLight)
{
   vec3 lightv=normalize(light-pt);
   float diffuse=dot(normal,lightv);
   vec3 refl=-reflect(lightv,normal);
   vec3 viewv=normalize(prp-pt);
   float specular=pow(max(dot(refl,viewv),0.0),spec);
   return (max(diffuse,0.0)+ambLight)*color+specular;
}

vec2 rand3d_2d(vec3 co){
    return vec2(
      fract(sin(dot(co.xyz,vec3(27.2344,98.2142,57.2324)))*43758.5453)-0.5,
      fract(cos(dot(co.xyz,vec3(34.7483,42.8534,12.1234)))*53978.3542)-0.5);
}

float rand3d_1d(vec3 co){
    return fract(sin(dot(co.xyz,vec3(27.2344,98.2142,57.2324)))*43758.5453)-0.5;
}

//Util End

//Scene Start

vec2 obj(in vec3 p)
{ 
  vec3 fp=stepspace(p,2.0);;
  float d=sin(fp.x*0.3+0.5*4.0)+cos(fp.z*0.3+0.5*2.0);
  p.y=p.y+d;
  p.xz=sim2d(p.xz,2.0);
  float c1=length(max(abs(p)-vec3(0.6,0.6,0.6),0.0))-0.35;
  float c2=length(p)-1.0;
  float cf=sin(0.5)*0.5+0.5;
  return vec2(mix(c1,c2,cf),1.0);
}

vec3 obj_c(in vec3 q){
  vec3 p=fract((q+1.0)/4.0);
  p.x=p.x>.5?-p.x:p.x;
  p.x=p.z>.5?-p.x:p.x;  
  return p.x>.0?vec3(0):vec3(sin(q.x*0.25)+1.0,sin(q.z*0.25-q.x*0.125)+1.0,sin(-q.z*0.25-q.x*0.125)+1.0)*0.5;
}

//Scene End

float raymarching(
  in vec3 prp,
  in vec3 scp,
  in int maxite,
  in float precis,
  in float startf,
  in float maxd,
  out float objid)
{ 
  const vec3 e=vec3(0.1,0,0.0);
  vec2 s=vec2(startf,0.0);
  vec3 c,p,n;
  float f=startf;
  for(int i=0;i<256;i++){
    if (abs(s.x)<precis||f>maxd||i>maxite) break;
    f+=s.x;
    p=prp+scp*f;
    s=obj(p);
    objid=s.y;
  }
  if (f>maxd) objid=-1.0;
  return f;
}

vec3 camera(
  in vec3 prp,
  in vec3 vrp,
  in vec3 vuv,
  in float vpd,
  out vec3 u,
  out vec3 v)
{
  vec2 rnd=rand3d_2d(vec3(gl_FragCoord.xy,time));
  vec2 vPos=-1.0+2.0*(gl_FragCoord.xy+rnd)/resolution.xy;
  vec3 vpn=normalize(vrp-prp);
  u=normalize(cross(vuv,vpn));
  v=cross(vpn,u);
  vec3 scrCoord=prp+vpn*vpd+vPos.x*u*resolution.x/resolution.y+vPos.y*v;
  return normalize(scrCoord-prp);
}

vec3 normal(in vec3 p)
{
  //tetrahedron normal
  const float n_er=0.01;
  float v1=obj(vec3(p.x+n_er,p.y-n_er,p.z-n_er)).x;
  float v2=obj(vec3(p.x-n_er,p.y-n_er,p.z+n_er)).x;
  float v3=obj(vec3(p.x-n_er,p.y+n_er,p.z-n_er)).x;
  float v4=obj(vec3(p.x+n_er,p.y+n_er,p.z+n_er)).x;
  return normalize(vec3(v4+v1-v3-v2,v3+v4-v1-v2,v2+v4-v3-v1));
}

vec3 render(
  in vec3 prp,
  in vec3 scp,
  in int maxite,
  in float precis,
  in float startf,
  in float maxd,
  in vec3 background,
  in vec3 light,
  in float spec,
  in vec3 ambLight,
  out vec3 n,
  out vec3 p,
  out float f,
  out float objid)
{ 
  objid=-1.0;
  f=raymarching(prp,scp,maxite,precis,startf,maxd,objid);
  if (objid>-0.5){
    p=prp+scp*f;
    vec3 c=obj_c(p);
    n=normal(p);
    vec3 cf=phong(p,prp,n,light,c,spec,ambLight);
    return vec3(cf);
  }
  f=maxd;
  return vec3(background); //background color
}

void main(void){
 
  vec2 position = ( gl_FragCoord.xy / resolution.xy );
  //vec4 backpixel = texture2D(backbuffer, position); 
  
  //Camera animation
	
vec3 finalColor = vec3(0,0,0);
	#define COUNT  16
	#define COUNTF 16.0
  float ltime = time;
  for(int i = 0; i < COUNT; i++) {
	ltime += 1.0/COUNTF;
  const vec3 vuv=vec3(0,1,0);
  const vec3 vrp=vec3(0.0,0.0,0.0);
  float mx=mouse.x*PI*2.0;
  float my=mouse.y*PI/2.01; 
  vec3 prp=vrp+vec3(cos(my)*cos(mx),sin(my),cos(my)*sin(mx))*12.0; //Trackball style camera pos
  const float vpd=2.0;
  vec3 light=prp+vec3(5.0,0,5.0);
  
  vec3 u,v;
  vec3 scp=camera(prp,vrp,vuv,vpd,u,v); 

  //Depth of Field using a flat field lens and disk sampling for circle of confusion
  //
  //The focus is a plane, i think it's nice this way
  //The focus can also the curved using just the distance to the camera
  //Or just a point
  //
  //8bits color depth is not the best for this kind of stuff :(
  //We need a floating point target for pretty bokeh and better convergence...
  //
  vec3 vp=vrp-prp;
  vec3 focuspoint=prp+scp*(dot(vp,vp)/dot(vp,scp)); //flat field lens
  vec2 rnd=rand3d_2d(vec3(position*ltime,ltime))*1.0+0.5;
  rnd=vec2(sqrt(rnd.x)*cos(rnd.y),sqrt(rnd.x)*sin(rnd.y)); //random disk
  prp=prp+scp*1.0+rnd.x*u+rnd.y*v;
  scp=normalize(focuspoint-prp);

  vec3 n,p;
  float f,o;
  const float maxe=0.01;
  const float startf=0.1;
  const vec3 backc=vec3(0.0,0.0,0.0);
  const float spec=8.0;
  const vec3 ambi=vec3(0.1,0.1,0.1);
  
  vec3 c1=render(prp,scp,256,maxe,startf,60.0,backc,light,spec,ambi,n,p,f,o);
  c1=c1*max(1.0-f*.015,0.0);
  vec3 c2=backc;
  if (o>0.5){
    scp=reflect(scp,n);
    c2=render(p+scp*0.05,scp,32,maxe,startf,10.0,backc,light,spec,ambi,n,p,f,o);
  }
  c2=c2*max(1.0-f*.1,0.0);
  
  finalColor+=vec3(c1.xyz*0.75+c2.xyz*0.25)*(1.0/COUNTF); 
	
}
  gl_FragColor=vec4(sqrt(finalColor),1.0);
}