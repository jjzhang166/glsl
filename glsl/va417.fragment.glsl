// By @paulofalcao
//
// Blobs

#ifdef GL_ES
precision highp float;
#endif
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float makePoint(float x,float y,float fx,float fy,float sx,float sy,float t){
   float xx=x+sin(t*fx)*sx;
   float yy=y+cos(t*fy)*sy;
   return .1/sqrt(xx*xx+yy*yy);
}

void main( void ) {

   vec2 p=(gl_FragCoord.xy/resolution.x)*2.0-vec2(1.0,resolution.y/resolution.x);

   p=p*0.3;
   
   float x=p.x;
   float y=p.y;

   float a=
       makePoint(x,y,3.3,2.9,0.3,0.3,time*0.5);
   a=a+makePoint(x,y,1.9,2.0,0.4,0.4,time*0.2);
a=a+makePoint(x,y,1.9,2.0,0.4,0.4,time*0.5);
a=a+makePoint(x,y,6.9,2.0,0.2,0.4,time*0.2);
a=a+makePoint(x,y,1.9,2.0,0.4,0.4,time*0.5);
a=a+makePoint(x,y,3.9,2.0,0.8,0.8,time*0.2);
 
   
   float b=
       makePoint(x,y,1.2,1.9,0.3,0.3,time*0.5);
   b=b+makePoint(x,y,0.7,2.7,0.4,0.4,time*0.5);

   float c=
       makePoint(x,y,3.7,0.3,0.3,0.3,time*0.5);
   c=c+makePoint(x,y,1.9,1.3,0.4,0.4,time*0.5);

   
   vec3 d=vec3(a,b,c)/12.0;
   
   gl_FragColor = vec4(d.x,d.y,d.z,1.0);
}