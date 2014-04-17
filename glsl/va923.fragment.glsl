// By @paulofalcao
//
// Blobs changed by @hintz

#ifdef GL_ES
precision highp float;
#endif
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float makePoint(float x,float y,float fx,float fy,float sx,float sy,float t)
{
   float xx=x+sin(t*fx)*cos(t*sx)/mouse.x;
   float yy=y+cos(t*fy)*sin(t*sy)/mouse.y;
  
   return 0.4/sqrt(abs(xx*xx+yy*yy));
}

void main() 
{
   vec2 p=(gl_FragCoord.xy/resolution.x)*2.0-vec2(1.0,resolution.y/resolution.x);

   p=p*3.0;
   
   float x=p.x;
   float y=p.y;

   float a=makePoint(x,y,3.3,2.9,1.3,0.3,time);
   a+=makePoint(x,y,1.9,2.0,0.4,0.4,time);
   a+=makePoint(x,y,0.2,0.7,0.4,0.5,time);
   
   float b=makePoint(x,y,1.2,1.9,0.3,0.3,time);
   b+=makePoint(x,y,0.7,2.7,0.4,4.0,time);
   b+=makePoint(x,y,1.4,0.6,0.4,0.5,time);
   b+=makePoint(x,y,2.6,0.4,0.6,0.3,time);
   b+=makePoint(x,y,0.1,1.4,0.5,0.4,time);
   b+=makePoint(x,y,0.7,1.7,0.4,0.4,time);
   b+=makePoint(x,y,0.8,0.5,0.4,0.5,time);
   b+=makePoint(x,y,1.4,0.9,0.6,0.3,time);
   b+=makePoint(x,y,0.7,1.3,0.5,0.4,time);

   float c=makePoint(x,y,3.7,0.3,0.3,0.3,time);
   c+=makePoint(x,y,1.9,1.3,0.4,0.4,time);
   c+=makePoint(x,y,0.8,0.9,0.4,0.5,time);
   c+=makePoint(x,y,1.2,1.7,0.6,0.3,time);
   c+=makePoint(x,y,0.3,0.6,0.5,0.4,time);
   c+=makePoint(x,y,0.3,0.3,0.4,0.4,time);
   c+=makePoint(x,y,1.4,0.8,0.4,0.5,time);
   c+=makePoint(x,y,0.2,0.6,0.6,0.3,time);
   c+=makePoint(x,y,1.3,0.5,0.5,0.4,time);
   
   vec3 d=vec3(b*c,a*c,a*b)/100.0;
   
   gl_FragColor = vec4(2000.0,4655,d.z,1.0);
}