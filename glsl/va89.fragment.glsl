// By @paulofalcao
//
// Simple marble torus

#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;

//Util Start

float PI=3.14159265;

vec2 ObjUnion(in vec2 obj0,in vec2 obj1){
  if (obj0.x<obj1.x)
  	return obj0;
  else
  	return obj1;
}
//Util End

//Scene Start

//Floor
vec2 obj0(in vec3 p){
  return vec2(p.y+5.0,0);
}
//Floor Color (checkerboard)
vec3 obj0_c(in vec3 p){
 if (fract(p.x*.5)>.5)
   if (fract(p.z*.5)>.5)
     return vec3(0,0,0);
   else
     return vec3(1,1,1);
 else
   if (fract(p.z*.5)>.5)
     return vec3(1,1,1);
   else
     	return vec3(0,0,0);
}

float cubicPulse( float c, float w, float x )
{
    x = abs(x - c);
    if(x>w) return 0.;
    x /= w;
    return 1. - x*x*(3.-2.*x);
}

vec2 obj1(vec3 p){
  vec2 q = vec2(length(p.xz)-3.0,mod(p.y, 0.9)-0.5);

  float t = mod(time+p.y,2.)/2. * 2. * PI;
  float t2 = mod(time+p.y,1.)/1. * 2. * PI;
  float w = dot(normalize(p.xz), vec2(sin(t),cos(t))) * 0.5 + 0.5;
  w = max(dot(normalize(p.xz), vec2(sin(t2),cos(t2))) * 0.5 + 0.5, w);
  w = (sin(pow(w,115.)*PI-0.5*PI)*0.5+0.5)*0.4+0.2;

  float d=length(q)-0.50*w;
	return vec2(d,1);
}

//obj1 color
vec3 obj1_c(vec3 p){
 float t = mod(time,2.)/2. * 2. * PI;
  float t2 = mod(time,1.)/1. * 2. * PI;
  float w = dot(normalize(p.xz), vec2(sin(t),cos(t))) * 0.5 + 0.5;
  float w2 = dot(normalize(p.xz), vec2(sin(t2),cos(t2))) * 0.5 + 0.5;
  w = (sin(pow(w,115.)*PI-0.5*PI)*0.5+0.5);
  w2 = (sin(pow(w2,115.)*PI-0.5*PI)*0.5+0.5);
 return vec3(0.8*w+0.2,0.2,w2);
}

//Objects union
vec2 inObj(vec3 p){
  return ObjUnion(obj0(p),obj1(p));
}

//Scene End

void main(void){
  vec2 vPos=-1.0+2.0*gl_FragCoord.xy/resolution.xy;

  //Camera animation
  vec3 vuv=vec3(0,1,0);//Change camere up vector here
  vec3 vrp=vec3(0,0,0); //Change camere view here
  float mx=mouse.x*PI*2.0;
  float my=mouse.y*PI/2.01;
  vec3 prp=vec3(cos(my)*cos(mx),sin(my),cos(my)*sin(mx))*6.0; //Trackball style camera pos
  

  //Camera setup
  vec3 vpn=normalize(vrp-prp);
  vec3 u=normalize(cross(vuv,vpn));
  vec3 v=cross(vpn,u);
  vec3 vcv=(prp+vpn);
  vec3 scrCoord=vcv+vPos.x*u*resolution.x/resolution.y+vPos.y*v;
  vec3 scp=normalize(scrCoord-prp);

  //Raymarching
  const vec3 e=vec3(0.1,0,0);
  const float maxd=60.0; //Max depth
  vec2 s=vec2(0.1,0.0);
  vec3 c,p,n;

  float f=1.0;
  for(int i=0;i<30;i++){
    if (abs(s.x)<.01||f>maxd) break;
    f+=s.x;
    p=prp+scp*f;
    s=inObj(p);
  }
  
  if (f<maxd){
    if (s.y==0.0)
      c=obj0_c(p);
    else
      c=obj1_c(p);
    n=normalize(
      vec3(s.x-inObj(p-e.xyy).x,
           s.x-inObj(p-e.yxy).x,
           s.x-inObj(p-e.yyx).x));
    float b=dot(n,normalize(prp-p));
    gl_FragColor=vec4((b*c+pow(b,16.0))*(1.0-f*.01),1.0);//simple phong LightPosition=CameraPosition
  }
  else gl_FragColor=vec4(0,0,0,1); //background color
}
