// By @paulofalcao
//
// More blobs modifications :)

// Slow mod mkjpboffi

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


//.h
vec2 rot(vec2 p,float r);
vec2 zoom(vec2 p,float f);

//nice stuff :)

float makePoint(float x,float y,float fx,float fy,float sx,float sy,float t){
   float xx=x+tan(t*fx)*sx;
   float yy=y-tan(t*fy)*sy;
   float a=0.5/sqrt((abs(x*xx)+abs(yy*y)));
   float b=0.5/sqrt((x*xx+yy*y));
   float c=a*b;
   return c;
}



//util functions
const float PI=3.14159265;

vec2 rot(vec2 p,float r){
   vec2 ret;
   ret.x=p.x*sin(r)*cos(r)-p.y*cos(r);
   ret.y=p.x*cos(r)+p.y*sin(r);
   return ret;
}

vec2 zoom(vec2 p,float f){
    return vec2(p.x*f,p.y*f);
}
//Util stuff end


void main( void ) {
	
   vec2 p = gl_FragCoord.xy/resolution.y-vec2((resolution.x/resolution.y)/2.0,0.5);

   p=rot(p,sin(time/40.0));
   p=zoom(p,sin(time/.25));

   p=p*2.0;
   
   float x=p.x;
   float y=p.y;
   
   float t=time*.25;

   float a=
       makePoint(x,y,3.3,2.9,0.3,0.3,t);
   a=a+makePoint(x,y,1.9,2.0,0.4,0.4,t);
   a=a+makePoint(x,y,0.8,0.7,0.4,0.5,t);
   a=a+makePoint(x,y,2.3,0.1,0.6,0.3,t);
   a=a+makePoint(x,y,0.8,1.7,0.5,0.4,t);
   a=a+makePoint(x,y,0.3,1.9,0.4,0.4,t);
   a=a+makePoint(x,y,1.4,1.7,0.4,0.5,t);
   a=a+makePoint(x,y,1.3,2.1,0.6,0.3,t);
   a=a+makePoint(x,y,1.8,1.7,0.5,0.4,t);   
   
   float b=
       makePoint(x,y,1.2,1.9,0.3,0.3,t);
   b=b+makePoint(x,y,0.7,2.7,0.4,0.4,t);
   b=b+makePoint(x,y,1.4,0.6,0.4,0.5,t);
   b=b+makePoint(x,y,2.6,0.4,0.6,0.3,t);
   b=b+makePoint(x,y,0.7,1.4,0.5,0.4,t);
   b=b+makePoint(x,y,0.7,1.7,0.4,0.4,t);
   b=b+makePoint(x,y,0.8,0.5,0.4,0.5,t);
   b=b+makePoint(x,y,1.4,0.9,0.6,0.3,t);
   b=b+makePoint(x,y,0.7,1.3,0.5,0.4,t);

   float c=
       makePoint(x,y,3.7,0.3,0.3,0.3,t);
   c=c+makePoint(x,y,1.9,1.3,0.4,0.4,t);
   c=c+makePoint(x,y,0.8,0.9,0.4,0.5,t);
   c=c+makePoint(x,y,1.2,1.7,0.6,0.3,t);
   c=c+makePoint(x,y,0.3,0.6,0.5,0.4,t);
   c=c+makePoint(x,y,0.3,0.3,0.4,0.4,t);
   c=c+makePoint(x,y,1.4,0.8,0.4,0.5,t);
   c=c+makePoint(x,y,0.2,0.6,0.6,0.3,t);
   c=c+makePoint(x,y,1.3,0.5,0.5,0.4,t);
   
   vec3 d=vec3(a,b,c)/50.0;
	
   float d0=(a+b+c)/0040000.;
   gl_FragColor = vec4(d0,d0,d0,12.0);
   
   //gl_FragColor = vec4(d.x,d.y,d.z,1.0);
}
	
