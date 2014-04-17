#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;

float PI=2.14;

vec2 ObjUnion(in vec2 obj0,in vec2 obj1){
  return (obj0.x<obj1.x) ? obj0 : obj1;
}

vec2 obj0(in vec3 p){
  return vec2(p.y+3.0,0);
}

vec3 obj0_c(in vec3 p){
 if (fract(p.x*.5)>.5)
   return (fract(p.z*.5)>.5) ? vec3(0,0,0): vec3(1,1,1);
 else
   return (fract(p.z*.5)>.5) ? vec3(1,1,1) : vec3(0,0,0);
}

vec2 obj1(in vec3 p){
  return vec2(length(max(abs(p)-vec3(1.0,1.0,1.0),0.0))-0.25,1);
}

vec3 obj1_c(in vec3 p){
  return vec3(1.0,0.5,0.2);
}

vec2 torus(vec3 p,float rT,float rR) {
  return vec2(length(vec2(length(p.xz) - rT,p.y)) - rR, 1.);
}

vec2 capsule(vec3 p, float r, float c) {
  return vec2(mix(length(p.xz)-r, length(vec3(p.x,abs(p.y)-c,p.z))-r, step(c,abs(p.y))), 1.);
}

vec2 inObj(in vec3 p){
	vec2 r = obj0(p);
	vec3 q = p + vec3(0., -.25-3.*abs(sin(time * 15.0)), 0.);
	q.x += 5.0 * sin(time * 5.);
	q.z += 5.0 * cos(time * 3.);
	
	r = ObjUnion(r, capsule(q, .5, 1.5));
	r = ObjUnion(r, vec2(length(q+vec3(-.5, 1.5, 0.)) - 0.75, 1.));
	r = ObjUnion(r, vec2(length(q+vec3(.5, 1.5, 0.)) - 0.75, 1.));
	r = ObjUnion(r, vec2(length(q+vec3(0, -1.5, 0.)) - .75, 1.));
	
  return r;
}

void main(void){
  vec2 vPos=-1.0+2.0*gl_FragCoord.xy/resolution.xy;

  vec3 vuv=vec3(0,1,0);//Change camere up vector here
  vec3 vrp=vec3(0.0,mouse.y * 10.0,0); //Change camere view here
  float mx=mouse.x*PI*2.0 * 5.0;
  float my=0.8*PI/2.01;  
  vec3 prp=vec3(10.0); //Trackball style camera pos - Change camera path position here

  //Camera setup
  vec3 vpn=normalize(vrp-prp);
  vec3 u=normalize(cross(vuv,vpn));
  vec3 v=cross(vpn,u);
  vec3 vcv=(prp+vpn);
  vec3 scrCoord=vcv+vPos.x*u*resolution.x/resolution.y+vPos.y*v;
  vec3 scp=normalize(scrCoord-prp);
  const vec3 e=vec3(0.1,0,0);
  const float maxd=60.0; //Max depth

  vec2 s=vec2(0.1,0.0);
  vec3 c,p,n;

  float f=1.0;
  for(int i=0;i<64;i++){
    if (abs(s.x)<.01||f>maxd) break;
    f+=s.x;
    p=prp+scp*f;
    s=inObj(p);
  }
  
  if (f<maxd) {
    c = (s.y==0.0) ? obj0_c(p) : obj1_c(p);
 
    const float n_er=0.01;
    float v1=inObj(vec3(p.x+n_er,p.y-n_er,p.z-n_er)).x;
    float v2=inObj(vec3(p.x-n_er,p.y-n_er,p.z+n_er)).x;
    float v3=inObj(vec3(p.x-n_er,p.y+n_er,p.z-n_er)).x;
    float v4=inObj(vec3(p.x+n_er,p.y+n_er,p.z+n_er)).x;
    n=normalize(vec3(v4+v1-v3-v2,v3+v4-v1-v2,v2+v4-v3-v1));
    
    float b=dot(n,normalize(prp-p));
    gl_FragColor=vec4((b*c+pow(b,8.0))*(1.0-f*.01),1.0);//simple phong LightPosition=CameraPosition
  }
  else gl_FragColor=vec4(0,0,0,1); //background color
}