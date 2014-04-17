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
  return vec2(p.y+13.0,0);
}
//Floor Color (checkerboard)
vec3 obj0_c(in vec3 p){
 if (fract(p.x*.15)>.5)
   if (fract(p.z*.15)>.5)
     return vec3(0,0,0);
   else
     return vec3(10,0,1);
 else
   if (fract(p.z*.15)>.5)
     return vec3(1,1,1);
   else
     	return vec3(0,0,0);
}

//IQs RoundBox (try other objects http://www.iquilezles.org/www/articles/distfunctions/distfunctions.htm)
vec2 obj1(in vec3 p){
	
  return vec2(length(max(abs(p) -vec3(1.0,1.0,1.0),0.0))-0.01,1);
}


// SNIPPP
// ------
vec2 f(vec3 p) {
	/*
	vec3 p0 = p;
	vec3 p1 = p;
	
	p0.xz = mod(p0.xz,4.) - 2.;
	p1.xz = mod(p1.xz+2.,4.) - 2.;
	p1.y += 0.3;
	
	float d0 = obj1(p0).x;
	float d1 = obj1(p1).x;

	float d = min(d0, d1);
	*/
	
	float zz = mod(p.z, 2.0);
	
	vec3 p0 = vec3(

		mod(p.x, 2.0),
		mod(p.y, 2.0),
		zz);
	float d = obj1(p0).x;
	return vec2(d, 0);
}
// ------

//Objects union
vec2 inObj(in vec3 p){
  return f(p);
}

//Scene End

void main(void){
  vec2 vPos=-1.0+2.0*gl_FragCoord.xy/resolution.xy;

  //Camera animation
  vec3 vuv=vec3(0,1,0);//Change camere up vector here
  vec3 vrp=vec3(0,1,0); //Change camere view here
  float t = time*0.25;
  vec3 prp=vec3(-sin(t)*3.0,4,cos(t)*4.0); //Change camera path position here
//	prp.x += mouse.y*10;
	
prp.x += (mouse.x-0.5) * 10.0;
prp.y += (mouse.y-0.5) * 10.0;

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

  float f=0.1;
  for(int i=0;i<200;i++){
    p = prp + scp * f;
    s = inObj(p);
    if (abs(s.x)<.1||f>maxd) break;
    // f += s.x;
    f += 0.03;
  }
  if (f<maxd){
    float b = 1.0 - f/5.0;
	
	  float ut = length(vcv)*b;
	  
    gl_FragColor=vec4(b*ut,b*0.6,b,1.0);	  
  }
  else gl_FragColor=vec4(0,0,0,1); //background color
}