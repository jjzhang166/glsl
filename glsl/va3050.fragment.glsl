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
   float xx=x+sin(t*fx)*sx*3.0;
   float yy=y+cos(t*fy)*sy*3.0;
   return 1.0/sqrt(xx*yy*0.005+yy*xx*0.005);
}

void main( void ) {

   vec2 p=(gl_FragCoord.xy/resolution.x)*3.0-vec2(1.0,resolution.y/resolution.x);

   p=p*2.0;
   
   float x=p.x;
   float y=p.y;

   float a=
       makePoint(x,y,3.3,2.9,0.3,0.3,time*100.0);
  
   
   float b=
       makePoint(x,y,1.2,1.9,0.3,0.3,time*100.0);


   float c=
       makePoint(x,y,3.7,0.3,0.3,0.3,time*100.0);
   
   vec3 d=vec3(a,b,c)/32.0;
   
   gl_FragColor = vec4(d.x,d.y,d.z,0.1);
}