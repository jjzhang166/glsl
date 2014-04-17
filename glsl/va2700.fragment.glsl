// Modified cheese cube by Dennis Hjorth. twitter.com/dennishjorth

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

//Sphere
float sph( vec3 p, float s ) {
  return length(p)-s;
}

//Floor Color (checkerboard)
vec3 obj0_c(in vec3 p){
     	return vec3(.2,.3,1.0);
}

//IQs RoundBox (try other objects http://www.iquilezles.org/www/articles/distfunctions/distfunctions.htm)
vec2 obj1(in vec3 p){
	float a1 = p.x*0.2+p.y*0.1+time;
	float a2 = p.x*0.2+p.y*0.1+time*0.2;
	vec3 p1 = vec3(p.x*cos(a1)+p.z*sin(a1),p.y,p.z*cos(a1)-p.x*sin(a1));
	p = vec3(p1.x,p1.y*cos(a2)+p1.z*sin(a2),p1.z*cos(a2)-p1.y*sin(a2));
	float r = (abs(p.x)+abs(p.y)+abs(p.z))-5.1;
	float modxy = (p.x*p.x+p.y*p.y+p.z*p.z)*0.1;
	float modd = (sin(cos(time*0.1)*0.5+0.3+modxy+sin(time*0.1+modxy))*.285+.795);
	vec3 p2 = mod(p, modd)-modd*.5;
	float s = sph(p2, .5);
	//return vec2(min(rb, s),1);
	return vec2(max(r, -s),0);
}

//RoundBox with simple solid color
vec3 obj1_c(in vec3 p){
	return vec3(.2,.3,1.0);
}

//Objects union
vec2 inObj(in vec3 p){
  return obj1(p);
}

//Scene End

void main(void){
  vec2 vPos=-1.0+2.0*gl_FragCoord.xy/resolution.xy;

  //Camera animation
  vec3 vuv=vec3(0,1,0);//Change camere up vector here
  vec3 vrp=vec3(0,1,0); //Change camere view here
  vec3 prp=vec3(-sin(time*.2)*8.0,sin(time*.3)*5.0,cos(time*.4)*8.0); //Change camera path position here

  //Camera setup
  vec3 vpn=normalize(vrp-prp);
  vec3 u=normalize(cross(vuv,vpn));
  vec3 v=cross(vpn,u);
  vec3 vcv=(prp+vpn);
  vec3 scrCoord=vcv+vPos.x*u*resolution.x/resolution.y+vPos.y*v;
  vec3 scp=normalize(scrCoord-prp);

  //Raymarching
  const vec3 e=vec3(0.025,0,0);
  const float maxd=60.0; //Max depth

  vec2 s=vec2(0.1,0.0);
  vec3 c,p,n;

  float f=1.0;
  for(int i=0;i<256;i++){
    if (abs(s.x)<.01||f>maxd) break;
    f+=s.x*.5;
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
    gl_FragColor=vec4((b*c+pow(b,64.0))*(1.0-f*.01),1.0);//simple phong LightPosition=CameraPosition
  }
  else gl_FragColor=vec4(0,0,0,1); //background color
}