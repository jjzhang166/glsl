// By @paulofalcao - some blobs modifications with symmetries. 
// Shrunk to fit in a page; paul's orig is nicer!

// @mod* rotwang


#ifdef GL_ES
precision mediump float;
#endif
#define PI 3.14159265
uniform float time;
uniform vec2 mouse, resolution;

vec3 sim(vec3 p,float s); //.h
vec2 rot(vec2 p,float r);
vec2 rotsim(vec2 p,float s);

vec2 makeSymmetry(vec2 p){ //nice stuff :)
   vec2 ret=p;
   ret=rotsim(ret,sin(time*0.3)*2.0+1.5);
   ret.x=abs(ret.x);
   return ret;
}

float makePoint(float x,float y,float fx,float fy,float sx,float sy,float t){
   float xx=x+tan(t*fx)*sx;
   float yy=y-tan(t*fy)*sy;
   return 4.0/sqrt(abs(x*xx+yy*yy));
}

vec3 sim(vec3 p,float s){
   vec3 ret=p;
   ret=p+s/2.0;
   ret=fract(ret/s)*s-s/2.0;
   return ret;
}

vec2 rot(vec2 p,float r){
   vec2 ret;
   ret.x=p.x*cos(r)-p.y*sin(r);
   ret.y=p.x*sin(r)+p.y*cos(r);
   return ret;
}

vec2 rotsim(vec2 p,float s){
   vec2 ret=p;
   ret=rot(p,-PI/(s*2.0));
   ret=rot(p, tan(ret.x)/PI*s);
	
	
   return ret;
}

void main( void ) {
	float aspect = resolution.y/resolution.x;
   vec2 p=(gl_FragCoord.xy/resolution.x)*2.0-vec2(1.0,aspect);
   p=makeSymmetry(p); 
   float x=p.x;
   float y=p.y;
   float t=time*0.1;
   float a= makePoint(x,y,0.3,3.0,0.3,0.3,t);
        a=a+makePoint(x,y,1.8,1.7,0.5,0.4,t);      
   float b=makePoint(x,y,1.2,1.9,0.3,0.3,t);
       b=b+makePoint(x,y,0.7,2.7,0.4,0.4,t);
   float c=makePoint(x,y,3.7,0.3,0.3,0.3,t);
       c=c+makePoint(x,y,0.8,0.9,0.4,0.5,t);
	float rt = 55.0;
  gl_FragColor = vec4(a/rt,b/rt,c/rt,1.0);
}