#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float sphere(vec3 p)
{
	vec3 n = vec3(p.y*p.z, 0.0, 0.0);
	//p.x=p.y*p.z;
	//p.z=2.0;
	//p.y=2.0;
	return length(n)-5.0;
}

float displacement(vec3 p)
{
	return cos(p.x)*cos(p.y)*cos(p.z);
}

float obj( vec3 p )
{
	float d1 = sphere(p);
    	float d2 = displacement(p);
    	return max(d1,d2);
}

vec3 obj_c( vec3 p ){
	return vec3(.3,0.1,0.8);
}
	
void main( void ) {
  vec2 vPos=-1.0+2.0*gl_FragCoord.xy/resolution.xy;

  //Camera animation
  vec3 vuv=vec3(0.6,0.0,0.6);//Change camere up vector here
  vec3 vrp=vec3(01.6, 2, 1.8); //Change camere view here 
  vec3 prp=vec3(sin(time*0.3)*4.0, 0.0 + cos(time*0.2)*14.0, -15.1);
	
  //Camera setup
  vec3 vpn=normalize(vrp-prp);
  vec3 u=normalize(cross(vuv,vpn));
  vec3 v=cross(vpn,u);
  vec3 vcv=(prp+vpn);
  vec3 scrCoord=vcv+vPos.x*u*resolution.x/resolution.y+vPos.y*v;
  vec3 scp=normalize(scrCoord-prp);

  //Raymarching
  const float maxd=40.0; //Max depth
  const vec2 e=vec2(0.1, -0.1);
  float s=0.81;
  vec3 c,p,n;

  float f=20.0;
	
  for(int i=0;i<12;i++){
    if (abs(s)<e.x||f>maxd) break;
    f+=s;
    p=prp+scp*f;
    s=obj(p);
  }
  
  if (f<maxd){
    c=obj_c(p);
    vec4 v=vec4(
	    obj(vec3(p+e.xyy)),obj(vec3(p+e.yyx)),
	    obj(vec3(p+e.yxy)),obj(vec3(p+e.xxx)));
    n=normalize(vec3(v.w+v.x-v.z-v.y,(v.z+v.w-v.x-v.y),v.y+v.w-v.z-v.x));
    float b=dot(n,normalize(prp-p));
    gl_FragColor=vec4((b*c+pow(b,8.0))*(1.0-f/maxd) + (f/maxd)*vec3(0.8,0,0) ,1.0);
  }
  //else gl_FragColor=vec4(0.2, 0.2, 0.2, 0.1); //background color
}