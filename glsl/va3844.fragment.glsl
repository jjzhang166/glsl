// Torus - TorusJourney
//
// by @paulofalcao
// rotwang: @mod*

#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;

float vs = 32.0;
//Util Start
float PI=3.14159265;

vec2 ObjUnion(in vec2 obj0,in vec2 obj1){
  if (obj0.x<obj1.x)
    return obj0;
  else
    return obj1;
}
vec3 sim(vec3 p,float s){
   vec3 ret=p;
   ret=p+s/2.0;
   ret=fract(ret/s)*s-s/2.0;
   return ret;
}

vec2 rot(vec2 p,float r){
   vec2 ret;
   ret.x=p.x*cos(r)-p.y*sin(r);
   ret.y=p.x*sin(r)+p.y*cos(r);
   return ret;
}

vec2 rotsim(vec2 p,float s){
   vec2 ret=p;
   ret=rot(p,-PI/(s*2.0));
	
   ret=rot(p,floor(atan(ret.x,ret.y)/PI*s)*(PI/s));
   return ret;
}

#define _union(a,b) min(a,b)
#define _subtraction(a,b) max(-a,b)
#define _intersect(a,b) max(a,b)
//Util End

//Scene Start
vec2 obj0(in vec3 p)
{
	
  p.y=p.y+1.5;
	float dom = 1.5;
  p.xz = mod(p.xz,dom)-0.5*dom;
	vec2 azz = abs(p.xz);
p.xz = clamp(vec2(0.0),vec2(0.5),azz);
	
  p.xz=rotsim(p.xz,3.0);
 
  p.yz=rotsim(p.yz,3.0); 
  p.z=p.z-0.5;
  p.xy=rotsim(p.xy,2.0);
	
vec3 ap = abs(p);
 
  float c=length(max(ap-vec3(1.0/ 8.0,0.25,0.03),0.0));

	
  return vec2(c,0);
}
//Floor Color 
vec3 obj0_c(in vec3 p){
  return vec3(0.2,0.6,0.8);
}



//Objects union
vec2 inObj(in vec3 p){
  return obj0(p); 
}

//Scene End

void main(void){
  vec2 vPos=-1.0+2.0*gl_FragCoord.xy/resolution.xy;
 
	float speed = time*0.05;
	
  //Camera animation
  vec3 vuv=vec3(0,1,0);//Change camere up vector here
  vec3 vrp=vec3(sin(speed)*vs,0.0,cos(speed)*vs);
  vec3 prp=vec3(sin(speed-0.1)*vs,0.0,cos(speed-0.1)*vs);
  float vpd=1.5;  
 
  //Camera setup
  vec3 vpn=normalize(vrp-prp);
  vec3 u=normalize(cross(vuv,vpn));
  vec3 v=cross(vpn,u);
  vec3 scrCoord=prp+vpn*vpd+vPos.x*u*resolution.x/resolution.y+vPos.y*v;
  vec3 scp=normalize(scrCoord-prp);

  //Raymarching
  const vec3 e=vec3(0.0,0,0);
  const float maxd=50.0; //Max depth

  vec2 s=vec2(0.1,0.0);
  vec3 c,p,n;

  float f=0.001;
  for(int i=0;i<256;i++){
    if (abs(s.x)<.0001||f>maxd) break;
    f+=s.x;
    p=prp+scp*f;
    s=inObj(p);
  }
  
  if (f<maxd){
    if (s.y==0.0)
      c=obj0_c(p);
   
 
    //tetrahedron normal
    const float n_er=0.01;
    float v1=inObj(vec3(p.x+n_er,p.y-n_er,p.z-n_er)).x;
    float v2=inObj(vec3(p.x-n_er,p.y-n_er,p.z+n_er)).x;
    float v3=inObj(vec3(p.x-n_er,p.y+n_er,p.z-n_er)).x;
    float v4=inObj(vec3(p.x+n_er,p.y+n_er,p.z+n_er)).x;
    n=normalize(vec3(v4+v1-v3-v2,v3+v4-v1-v2,v2+v4-v3-v1));
    
    float b=dot(n,normalize(prp-p));
    gl_FragColor=vec4((b*c+pow(b,8.0))*(1.0-f*.05),1.0);//simple phong LightPosition=CameraPosition
  }
  else gl_FragColor=vec4(0,0,0,1); //background color
}