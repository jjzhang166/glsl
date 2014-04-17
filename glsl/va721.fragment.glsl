// // // // // // // // 
// // BY PICCOLA ELE
// // // // // // // // 




#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float makePoint(float x,float y,float fx,float fy,float sx,float sy,float t){
   float xx=x+tan(t*fx)*sx;
   float yy=y+tan(t*fy)*sy;
   return 0.30/sqrt(abs(x*xx+y*yy));
}

void main( void ) {

   vec2 p=(gl_FragCoord.xy/resolution.x)*2.0-vec2(3.50,resolution.y/resolution.x);
  
   float t = time / 10.0;

   p=p*0.10;
   
   float x=p.x;
   float y=p.y;

   float a=
       makePoint(x,y,3.3,2.1,0.3,0.3,t);
   a=a+makePoint(x,y,1.9,2.0,0.4,0.4,t);
   a=a+makePoint(x,y,0.8,0.7,0.4,0.5,t);
   a=a+makePoint(x,y,2.3,0.1,0.6,0.3,t);
   a=a+makePoint(x,y,0.8,1.7,0.5,0.4,t);
   a=a+makePoint(x,y,0.3,1.0,0.4,0.4,t);
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
   
  float D=
       makePoint(x,y,3.7,0.3,0.3,0.3,t);
   D=c+makePoint(x,y,1.9,1.3,0.4,0.4,t);
   D=c+makePoint(x,y,0.8,0.9,0.4,0.5,t);
   D=c+makePoint(x,y,1.2,1.7,0.6,0.3,t);
   D=c+makePoint(x,y,0.3,0.6,0.5,0.4,t);
   D=c+makePoint(x,y,0.3,0.3,0.4,0.4,t);
   D=c+makePoint(x,y,1.4,0.8,0.4,0.5,t);
   D=c+makePoint(x,y,0.2,0.6,0.6,0.3,t);
   D=c+makePoint(x,y,1.3,0.5,0.5,0.4,t);
  
  float e=
       makePoint(x,y,1.7,0.3,0.3,0.3,t);
   e=c+makePoint(x,y,4.9,1.3,0.4,0.4,t);
   e=c+makePoint(x,y,0.8,10.9,0.4,0.5,t);
   e=c+makePoint(x,y,11.2,1.7,0.6,0.3,t);
   e=c+makePoint(x,y,0.3,0.6,0.5,0.4,t);
   e=c+makePoint(x,y,10.3,0.3,0.4,0.4,t);
   e=c+makePoint(x,y,1.4,0.8,0.3,3.5,t);
   e=c+makePoint(x,y,0.2,0.6,0.6,4.3,t);
   e=c+makePoint(x,y,1.3,10.5,9.5,4.4,t);
   

   

   vec3 d=vec3(a,b,c)/32.0;
   
   gl_FragColor = vec4(d.x,d.y,d.z,1.0);
}