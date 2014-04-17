#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;

vec3 c;
vec3 last_hit;
vec3 last_uvw;

vec3 center(float delta) {
	vec3 v;
	float t = time/10.0 - delta;
	v.x = 1.0 * sin(t*3.1) + cos(t*0.9);
	v.y = 1.0 * cos(t*2.1) + sin(t*1.9);
	v.z = 1.0 * sin(t*2.8) * sin(t*1.4);
	return v;
}

vec4 obj1(in vec3 p) {	
	vec3 w = vec3(p);
	vec3 b0 = center(0.0);
	vec3 b1 = center(1.8);
	vec3 b2 = center(2.5);	
	vec3 d0, d1, d2;
	float l0, l1, l2;
	l0 = length(p - b0) - 0.75;
	l1 = length(p - b1) - 0.75;
	l2 = length(p - b2) - 0.75;
	float l = (l0*l1*l2) + 0.25;
	return vec4(l,p.x*b0.x,p.y*b1.y,p.z*b2.z);
}

/*
float obj1_dist(in vec3 origin, in vec3 delta) {
	
	
	
	return vec4(99,0,0,0);
}

vec4 obj1_color(in vec3 pt) {}
*/


//Scene End

void main(void){
  c = vec3(-0.78, 0.15, 0.07);
  c.x += (mouse.x-0.5)*1.0;
  c.z += (mouse.y-0.5)*3.0;
  vec2 vPos=-1.0+2.0*gl_FragCoord.xy/resolution.xy;
  vec3 vuv=vec3(0,1,0);//Change camere up vector here
  vec3 vrp=vec3(0,0,0); //Change camere view here
  float t = time*0.5;
  vec3 prp=vec3(-sin(t)*1.0, 0.0, cos(t)*1.0); //Change camera path position here
  prp *= 3.0;
  vec3 vpn=normalize(vrp-prp);
  vec3 u=normalize(cross(vuv,vpn));
  vec3 v=cross(vpn,u);
  vec3 vcv=(prp+vpn);
  vec3 scrCoord=vcv+vPos.x*u*resolution.x/resolution.y+vPos.y*v;
  vec3 scp=normalize(scrCoord-prp);
  const float maxd=160.0; //Max depth
  vec4 s=vec4(9,0,0,0);
  vec3 c,p,n;
  float f=0.5;
  for(int i=0;i<50;i++){
  	  p = prp + scp * f;
	  s = obj1(p);
	  if (s.x<=1.0) break;
	  f += 0.3;
	  if (f>maxd) break;
  }
  if (f<maxd){
    float b = 1.5 - f/7.0;
	  vec3 n = vec3(s.y,s.z,s.w);
	  b *= 0.5+dot(n, normalize(prp));
    gl_FragColor=vec4(0.7,0.85,1.0,1.0)*b;	  
  }
  else gl_FragColor=vec4(0,0,0,1); //background color
}