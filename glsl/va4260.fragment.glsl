#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;
//Simple raymarching sandbox with camera

//Raymarching Distance Fields
//About http://www.iquilezles.org/www/articles/raymarchingdf/raymarchingdf.htm
//Also known as Sphere Tracing
//Original seen here: http://twitter.com/#!/paulofalcao/statuses/134807547860353024

//Util Start
vec2 ObjUnion(in vec2 obj_floor,in vec2 obj_roundBox){
  if (obj_floor.x<obj_roundBox.x)
  	return obj_floor;
  else
  	return obj_roundBox;
}
//Util End

//Scene Start

//Torus
float torus(in vec3 p, in vec2 t){
	vec2 q = vec2(length(vec2(p.x,p.z))-t.x, p.y);
	return length(q) - t.y;
}

//Sphere
float sphere(in vec3 p, float radius){
	float length = sqrt(p.x*p.x + p.y*p.y + p.z*p.z);
	return length-radius;
}

//Floor
vec2 obj_floor(in vec3 p){
  return vec2(p.y+3.0,0);
}
//Floor Color (checkerboard)
vec3 obj_floor_c(in vec3 p){
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

//IQs RoundBox (try other objects http://www.iquilezles.org/www/articles/distfunctions/distfunctions.htm)
vec2 obj_roundBox(in vec3 p){
  return vec2(length(max(abs(p)-vec3(1,1,1),0.0))-0.25,1);
}

vec2 obj_sphere(in vec3 p){
  return vec2(length(p)-2.0);

}

float sdHexPrism( vec3 p, vec2 h )
{
    vec3 q = abs(p);
    return max(q.z-h.y,max(q.x+q.y*0.57735,q.y*1.1547)-h.x);
}

//RoundBox with simple solid color
vec3 obj_roundBox_c(in vec3 p){
	return vec3(0.9,0.6,0.9);
}

//Objects union
vec2 inObj(in vec3 p){
	vec2 abc = obj_sphere(p);
	return abc;	
  //return ObjUnion(obj_floor(p),obj_roundBox(p));
}

//Scene End

void main(void){
  //Camera animation
  vec3 U=vec3(0,1,0);//Camera Up Vector
  vec3 viewDir=vec3(0,0,0); //Change camere view vector here
  vec3 E=vec3(-sin(time / 8.0)*8.0,4,cos(time / 8.0)*8.0); //Camera location; Change camera path position here
  //vec3 E=vec3(mouse.x*4.0, 4, mouse.y*4.0); //Camera location; Change camera path position here
	
  //Camera setup
  vec3 C=normalize(viewDir-E);
  vec3 A=cross(C, U);
  vec3 B=cross(A, C);
  vec3 M=(E+C);
  
  vec2 vPos=2.0*gl_FragCoord.xy/resolution.xy - 1.0; // (2*Sx-1) where Sx = x in screen space (between 0 and 1)
  vec3 scrCoord=M + vPos.x*A*resolution.x/resolution.y + vPos.y*B; //normalize resolution in either x or y direction (ie resolution.x/resolution.y)
  vec3 scp=normalize(scrCoord-E);

  //Raymarching
  const vec3 e=vec3(0.1,0,0);
  const float MAX_DEPTH=60.0; //Max depth

  vec2 s=vec2(0.1,0.0);
  vec3 c,p,n;

  float f=1.0;
  for(int i=0;i<256;i++){
    if (abs(s.x)<.01||f>MAX_DEPTH) break;
    f+=s.x;
    p=E+scp*f;
    s=inObj(p);
  }
  
  if (f<MAX_DEPTH){
    if (s.y==0.0)
      c=obj_floor_c(p);
    else
      c=obj_roundBox_c(p);
    n=normalize(
      vec3(s.x-inObj(p-e.xyy).x,
           s.x-inObj(p-e.yxy).x,
           s.x-inObj(p-e.yyx).x));
    float b=dot(n,normalize(E-p));
    gl_FragColor=vec4((b*c+pow(b,8.0))*(1.0-f*.01),1.0);//simple phong LightPosition=CameraPosition
  }
  else gl_FragColor=vec4(0,0,0,1); //background color
}