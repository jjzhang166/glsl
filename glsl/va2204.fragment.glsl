#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;

//Raymarching Distance Fields

vec2 ObjUnion(in vec2 obj_floor,in vec2 obj_roundBox){
  if (obj_floor.x<obj_roundBox.x)
  	return obj_floor;
  else
  	return obj_roundBox;
}

vec2 obj_floor(in vec3 p){
  return vec2(p.y+3.0,0);
}

vec2 fblob(vec3 p) {
	// This is what I more or less recommend to use (TOP SECRET CODE FROM MERCURY - USE WITH CAUTION)
	float l = length(p);
	p = abs(normalize(p));
	p = mix(mix(p.zxy, p.yzx, step(p.z, p.y)), p, step(p.y, p.x) * step(p.z, p.x));
	float b = max(
		max(dot(p,vec3(.577)),
			dot(p.xz,vec2(.526,.851))), // <--- seems to be necessary (try specular reflections without it)
		max(dot(p.xz,vec2(.934,.357)),
			dot(p.xy,vec2(.851,.526))));
	// Three lines full of magic to play with:
	b = acos(b-0.01) / (3.1415*.5+sin(time));
	b = smoothstep(.25, 0.0, b);
	return vec2(l - 2.0 - b * b * .8, 1);
	// las/mercury - END OF TRANSMISSION - <3
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

//Objects union
vec2 inObj(in vec3 p){
  return ObjUnion(obj_floor(p),fblob(p));
}


void main(void){
  //Camera animation
  vec3 U=vec3(0,1,0);//Camera Up Vector
  vec3 viewDir=vec3(0,0,0); //Change camere view vector here
  vec3 E=vec3(-sin(time/2.)*8.0,4,cos(time/2.)*8.0); //Camera location; Change camera path position here
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
      c=vec3(0.7,0,0);
    n=normalize(
      vec3(s.x-inObj(p-e.xyy).x,
           s.x-inObj(p-e.yxy).x,
           s.x-inObj(p-e.yyx).x));
    float b=dot(n,normalize(E-p));
    gl_FragColor=vec4((c*b+pow(b,8.0))*(1.0-f*.01),1.0);//simple phong LightPosition=CameraPosition
  }
  else gl_FragColor=vec4(0,0,0,1); //background color
}