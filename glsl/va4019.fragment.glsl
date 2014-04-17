// Tile Waves
// 
// Another quick raymarching for fun :)
//
// by @paulofalcao
//

#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;

//******************
// Scene Start
//******************
vec2 sim2d(vec2 p,float s){
   vec2 ret=p;
   ret=p+s/2.0;
   ret=fract(ret/s)*s-s/2.0;
   return ret;
}

vec3 stepspace(vec3 p,float s){
  return p-mod(p-s/2.0,s);
}

vec2 rot(vec2 p,float r){
   vec2 ret;
   ret.x=p.x*cos(r)-p.y*sin(r);
   ret.y=p.x*sin(r)+p.y*cos(r);
   return ret;
}

vec2 obj(vec3 p){
  
  vec3 fp=stepspace(p,1.0);
  float d=sin(length(fp/2.0)*1.0-time*4.0)*(sin(length(fp/50.0)*4.0-time*1.0)*0.5+0.5);
	
  p.xz=sim2d(p.xz,1.0);
  p.xy=rot(p.xy,d*1.4); 
  p.xz=rot(p.xz,d*1.4);
  //using box-signed from http://www.iquilezles.org/www/articles/distfunctions/distfunctions.htm
  vec3 b=vec3(0.4,0.05,0.4);
  vec3 h=abs(p)-b;
  float c1=min(max(h.x,max(h.y,h.z)),0.0)+length(max(h,0.0));

  return vec2(c1,1.0);
}

vec3 obj_c(vec3 p,float objid){
  vec2 fp=sim2d(p.xz-0.5,2.0);
  if (fp.y>0.0) fp.x=-fp.x;
  if (fp.x>0.0) return vec3(0.0,0.0,0.0);
    else return vec3(1.0,0.5,0.2);   
}

//******************
// Scene End
//******************


float PI=3.14159265;

void main(void){
  vec2 vPos=-1.0+2.0*gl_FragCoord.xy/resolution.xy;

  //Camera animation
  vec3 vuv=vec3(0,1,0);//Change camere up vector here
  vec3 vrp=vec3(0,1,0); //Change camere view here
  float mx=mouse.x*PI*2.0;
  float my=mouse.y*PI/2.01;   
  vec3 prp=vrp+vec3(cos(my)*cos(mx),sin(my),cos(my)*sin(mx))*12.0; //Trackball style camera pos

  //Camera setup
  vec3 vpn=normalize(vrp-prp);
  vec3 u=normalize(cross(vuv,vpn));
  vec3 v=cross(vpn,u);
  vec3 vcv=(prp+vpn);
  vec3 scrCoord=vcv+vPos.x*u*resolution.x/resolution.y+vPos.y*v;
  vec3 scp=normalize(scrCoord-prp);

  //Raymarching
  const float maxd=60.0; //Max depth
  const vec2 e=vec2(0.01,-0.01);
  vec2 s=vec2(0.1,0.0);
  vec3 c,p,n;

  float f=1.0;
  for(int i=0;i<256;i++){
    if (abs(s.x)<e.x||f>maxd) break;
    f+=s.x;
    p=prp+scp*f;
    s=obj(p);
  }
  
  if (f<maxd){
    c=obj_c(p,s.y);
    vec4 v=vec4(
	    obj(vec3(p+e.xyy)).x,obj(vec3(p+e.yyx)).x,
	    obj(vec3(p+e.yxy)).x,obj(vec3(p+e.xxx)).x);
    n=normalize(vec3(v.w+v.x-v.z-v.y,v.z+v.w-v.x-v.y,v.y+v.w-v.z-v.x));
    float b=dot(n,normalize(prp-p));
    gl_FragColor=vec4((b*c+pow(b,8.0))*(1.0-f*.02),1.0);
  }
  else gl_FragColor=vec4(0,0,0,1); //background color
}