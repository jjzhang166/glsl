// by @paulofalcao
// mashing about by ishani @ ishani.org

#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform float time;

//Simple raymarching sandbox with camera

//Raymarching Distance Fields
//About http://www.iquilezles.org/www/articles/raymarchingdf/raymarchingdf.htm
//Also known as Sphere Tracing

//Util Start
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
  //obj deformation
	p.y += 2.0;
  p.y=p.y+sin(sqrt(p.x*p.x+p.z*p.z)-time*2.0)*0.5;
  p.y=p.y+cos(p.x-time*1.0)*0.25;
  p.y=p.y+cos(p.z-time*2.0)*0.25;
  //plane
 
  return vec2(p.y+3.0,0);
}
//Floor Color (checkerboard)
vec3 obj0_c(in vec3 p){
 if (fract(p.x*.5)>.5)
   if (fract(p.z*.5)>.5)
	return vec3(0.8,0.7,0.4);
   else
     return vec3(0.5,0.4,0.1);
 else
   if (fract(p.z*.5)>.5)
     return vec3(0.7,0.6,0.2);
   else
     	return vec3(0.4,0.3,0.0);
}

//IQs RoundBox (try other objects http://www.iquilezles.org/www/articles/distfunctions/distfunctions.htm)
vec2 obj1(in vec3 p){
  //obj deformation
  p.x=fract(p.x+0.5)-0.5;
  p.z=fract(p.z+0.5)-0.5;
  p.y=p.y-2.0+sin(time*1.0);
  return vec2(length(max(abs(p)-vec3(0.25,0.1,0.25),0.0))-0.5,1);
}

float length8(vec2 p)
{
  return pow((pow(p.x,8.0) + pow(p.y,8.0)), (1.0/8.0));
}


//RoundBox with simple solid color
vec3 obj1_c(in vec3 p)
{
 float n = length8(p.xz * 0.1);
 return vec3(1.0-n);
}


float sdTorus88( vec3 p, vec2 t )
{
  vec2 q = vec2(length8(p.xy)-t.x,p.z);
  return length8(q)-t.y;
}

vec2 obj2(in vec3 p){
  p.y = p.y + 1.75;
  vec2 t = vec2(1.75, (2.0 + sin(p.y + time * 3.0)) * 0.3);
  return vec2(sdTorus88(p, t), 2.0);
}

float rand(vec3 co){
    return fract(sin(dot(co ,vec3(11.9898,78.233,51.5213))) * 43758.5453);
}

// by rotwang / @emackey
vec3 obj2_c(in vec3 p){
vec3 clr = vec3(0.0);
for(int i=0;i<8;i++)
{
	float n = pow(4.0-float(i), 2.0);
	vec3 pos_z = floor(p*n);
	float a = 1.0-step(0.2, rand(pos_z));
	float rr = rand(pos_z)*a;
	float gg = rand(pos_z+n)*a;
	float bb = rand(pos_z+n+n)*a;
	
	vec3 clr_a = vec3(rr, gg, bb);
	clr += clr_a/2.0;
	p += vec3(0.0,0.5, 0.2) * time ;
}
return clr;
}

//Objects union
vec2 inObj(in vec3 p){
  return ObjUnion( ObjUnion(obj0(p),obj1(p)), obj2(p));
}

//Scene End

void main(void){
  vec2 vPos=-1.0+2.0*gl_FragCoord.xy/resolution.xy;

  //Camera animation
  vec3 vuv=vec3(0,1,sin(time*0.1));//Change camere up vector here
  vec3 prp=vec3(-sin(time*0.6)*8.0,-1,cos(time*0.4)*8.0); //Change camera path position here
  vec3 vrp=vec3(0,0,0); //Change camere view here


  //Camera setup
  vec3 vpn=normalize(vrp-prp);
  vec3 u=normalize(cross(vuv,vpn));
  vec3 v=cross(vpn,u);
  vec3 vcv=(prp+vpn);
  vec3 scrCoord=vcv+vPos.x*u*resolution.x/resolution.y+vPos.y*v;
  vec3 scp=normalize(scrCoord-prp);

  //Raymarching
  const vec3 e=vec3(0.1,0,0);
  const float maxd=50.0; //Max depth

  vec2 s=vec2(0.1,0.0);
  vec3 c,p,n;

  float f=1.0;
  for(int i=0;i<256;i++){
    if (abs(s.x)<.01||f>maxd) break;
    f+=s.x;
    p=prp+scp*f;
    s=inObj(p);
  }
  
  if (f<maxd){
    if (s.y==0.0)
      c=obj0_c(p);
    else if (s.y==1.0)
      c=obj1_c(p);
    else
      c=obj2_c(p);
	    
    n=normalize(
      vec3(s.x-inObj(p-e.xyy).x,
           s.x-inObj(p-e.yxy).x,
           s.x-inObj(p-e.yyx).x));
    float b=dot(n,normalize(prp-p));
    gl_FragColor=vec4((b*c+pow(b,8.0))*(1.0-f*.02),1.0);//simple phong LightPosition=CameraPosition
  }
  else gl_FragColor=vec4(0,0,0,1); //background color
}