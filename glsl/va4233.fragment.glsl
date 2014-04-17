#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;

vec2 obj1(in vec3 p) {

vec3 c = vec3(-0.58, 0.25, 0.17);
// vec3 c = vec3(-0.78, 0.15, 0.07);
// c = vec3(-0.4360393, 0.0147539, 0);
 c.x += (mouse.x-0.5)/1.0;
 c.z += (mouse.y-0.5)/1.0;

vec3 w=vec3(p);
//	w = p;
	// vec3 c = vec3((mouse.x-0.5)/10.0, (mouse.y-0.5)/10.0, -0.01);
	//c = vec3(0.16,0.05,0.01);
	// c = normalize(c) * 0.5;
	
	vec3 d;
	float l;
	for(int k=0; k<7; k++) {

		float nx = w.x * w.x - w.y * w.y - w.z * w.z;
		float ny = 2.0 * w.x * w.y;
		float nz = 2.0 * w.x * w.z;
		
		w = vec3(nx, ny, nz);
		w = w + c;
	
		d = p - w;
		l = length(d);
		
		if (l<=0.5) return vec2(l, 0);

	}
	
	// return vec2(l, 0);
	
	return vec2(99,0);
}


vec2 inObj(in vec3 p){
	vec3 p0 = p;
	float d = obj1(p0).x;
	return vec2(d, 0);
}

//Scene End

void main(void){
  vec2 vPos=-1.0+2.0*gl_FragCoord.xy/resolution.xy;

  //Camera animation
  vec3 vuv=vec3(0,1,0);//Change camere up vector here
  vec3 vrp=vec3(0,0,0); //Change camere view here
  float t = time*0.5;
  vec3 prp=vec3(-sin(t)*1.0, 0.0, cos(t)*1.0); //Change camera path position here
  prp *= 1.5;

  //Camera setup
  vec3 vpn=normalize(vrp-prp);
  vec3 u=normalize(cross(vuv,vpn));
  vec3 v=cross(vpn,u);
  vec3 vcv=(prp+vpn);

  vec3 scrCoord=vcv+vPos.x*u*resolution.x/resolution.y+vPos.y*v;
  vec3 scp=normalize(scrCoord-prp);

  //Raymarching
  // const vec3 e=vec3(0.1,0,0);
	
  const float maxd=60.0; //Max depth

  vec2 s=vec2(0.1,0.0);
  vec3 c,p,n;

  float f=1.0;
  for(int i=0;i<100;i++){
    p = prp + scp * f;
    s = inObj(p);
    if (abs(s.x)<0.5 ||f>maxd) break;
    // f += s.x;
    f += 0.01;
  }
  if (f<maxd){
    float b = 1.0 - f/3.0;
    gl_FragColor=vec4(b,b,b,1.0);	  
  }
  else gl_FragColor=vec4(0,0,0,1); //background color
}