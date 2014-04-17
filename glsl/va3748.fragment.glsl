//Simple raymarching sandbox with camera

//Raymarching Distance Fields
//About http://www.iquilezles.org/www/articles/raymarchingdf/raymarchingdf.htm
//Also known as Sphere Tracing

// rotwang: @mod+ gradient color, camera lift, tinted checker
#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform float time;



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
  return vec2(p.y+3.0,0);
}
//Floor Color (checkerboard)
vec3 tinted_checker(in vec3 p){
	
	vec3 clr = vec3(0,0,0);
 if (fract(p.x*.5)>.5)
   if (fract(p.z*.5)>.5)
     clr = vec3(0,0,0);
   else
      clr = vec3(.8,.8,.8);
 else
   if (fract(p.z*.5)>.5)
     clr = vec3(1,1,1);
   
	 float len = (1.0-length(p.xz))*0.025;
clr += vec3(len*8.0,0.5*len,0.25*len)*16.0;	 
    return clr;
}

//IQs RoundBox (try other objects http://www.iquilezles.org/www/articles/distfunctions/distfunctions.htm)
vec2 obj1(in vec3 p){
  return vec2(length(max(abs(p)-vec3(1,1,1),0.0))-0.25,1);
}

//RoundBox with gradient color
vec3 obj1_c(in vec3 p){
	
	vec3 clr = vec3(2.0,p.y+0.75,0.0);
	return clr;
}

//Objects union
vec2 inObj(in vec3 p){
  return ObjUnion(obj0(p),obj1(p));
}


float osc_usin(float speed)
{
	return sin(time*speed)*0.5+0.5;
}
//Scene End

void main(void){
  vec2 vPos=-1.0+2.0*gl_FragCoord.xy/resolution.xy;

  //Camera animation
float rt = time *0.25;	
	float lift = 0.5 + osc_usin(0.25)*3.0;
  vec3 vuv=vec3(0,1,0);//Change camere up vector here
  vec3 vrp=vec3(0,1,0); //Change camere view here
  vec3 prp=vec3(-sin(rt)*4.0,lift,cos(rt)*4.0); //Change camera path position here

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
  for(int i=0;i<256;i++){
    if (abs(s.x)<.01||f>maxd) break;
    f+=s.x;
    p=prp+scp*f;
    s=inObj(p);
  }
  
  if (f<maxd){
    if (s.y==0.0)
      c=tinted_checker(p);
    else
      c=obj1_c(p);
    n=normalize(
      vec3(s.x-inObj(p-e.xyy).x,
           s.x-inObj(p-e.yxy).x,
           s.x-inObj(p-e.yyx).x));
    float b=dot(n,normalize(prp-p));
	  
	  vec3 clr = (0.5*b*c+pow(b,32.0))*(1.0-f*.01);
    gl_FragColor=vec4( clr,1.0);//simple phong LightPosition=CameraPosition
  }
  else gl_FragColor=vec4(0,0,0,1); //background color
}