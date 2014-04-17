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
   float xx=x+sin(t*fx)*sx*sx;
   float yy=y+cos(t*fy)*sy;
   return 0.750/sqrt(xx*xx+yy*yy);
}

void main( void ) {

   vec2 p=(gl_FragCoord.xy/resolution.x)*2.0-vec2(1.0,resolution.y/resolution.x);

   p=p*1.5;
   
   float x=p.x;
   float y=p.y;

   float a=
       makePoint(x,y,9.9,9.9,1.1,9.9,time);
   a=a+makePoint(x,y,9.9,9.9,1.1,9.9,time);
   a=a+makePoint(x,y,9.9,9.9,1.1,9.9,time);
   a=a+makePoint(x,y,9.9,9.9,1.1,9.9,time);
   a=a+makePoint(x,y,9.9,9.9,1.1,9.9,time);
   a=a+makePoint(x,y,9.9,9.9,1.1,9.9,time);
   a=a+makePoint(x,y,9.9,9.9,1.1,9.9,time);
   a=a+makePoint(x,y,9.9,9.9,1.1,9.9,time);
   a=a+makePoint(x,y,9.9,9.9,1.1,9.9,time);   
   
   float b=
       makePoint(x,y,9.9,9.9,1.1,9.9,time);
   b=b+makePoint(x,y,9.9,9.9,1.1,9.9,time);
   b=b+makePoint(x,y,9.9,9.9,1.1,9.9,time);
   b=b+makePoint(x,y,9.9,9.9,1.1,9.9,time);
   b=b+makePoint(x,y,9.9,9.9,1.1,9.9,time);
   b=b+makePoint(x,y,9.9,9.9,1.1,9.9,time);
   b=b+makePoint(x,y,9.9,9.9,1.1,9.9,time);
   b=b+makePoint(x,y,9.9,9.9,1.1,9.9,time);
   b=b+makePoint(x,y,9.9,9.9,1.1,9.9,time);
   float c=
       makePoint(x,y,9.9,9.9,1.1,9.9,time);
   c=c+makePoint(x,y,9.9,9.9,1.1,9.9,time);
   c=c+makePoint(x,y,9.9,9.9,1.1,9.9,time);
   c=c+makePoint(x,y,9.9,9.9,1.1,9.9,time);
   c=c+makePoint(x,y,9.9,9.9,1.1,9.9,time);
   c=c+makePoint(x,y,9.9,9.9,1.1,9.9,time);
   c=c+makePoint(x,y,9.9,9.9,1.1,9.9,time);
   c=c+makePoint(x,y,9.9,9.9,1.1,9.9,time);
   c=c+makePoint(x,y,1.1,1.1,1.1,1.1,time);
   
   vec3 d=vec3(a,b,c)/32.0;
   
   gl_FragColor = vec4(d.x,d.y,d.z,1.0);
}