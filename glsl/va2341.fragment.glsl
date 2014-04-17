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
   float dist2 = xx*xx + yy*yy;
   return ((dist2 < .005) && (dist2 > .002)) ? 1.0 : 0.0;
}

void main( void ) {
	
  float t = mouse.x * 3.0;
  float nc = mouse.y;
   vec2 p=(gl_FragCoord.xy/resolution.x)*2.0-vec2(1.0,resolution.y/resolution.x);

   p=p*2.0;
   
   float x=p.x;
   float y=p.y;

   float a=
       makePoint(x,y,5.0,5.0,.7,.7,t);
   //a=a+makePoint(x,y,1.9,2.0,0.4,0.4,time);
   //a=a+makePoint(x,y,0.8,0.7,0.4,0.5,time);
   //a=a+makePoint(x,y,2.3,0.1,0.6,0.3,time);
   //a=a+makePoint(x,y,0.8,1.7,0.5,0.4,time);
   //a=a+makePoint(x,y,0.3,1.0,0.4,0.4,time);
   //a=a+makePoint(x,y,1.4,1.7,0.4,0.5,time);
   //a=a+makePoint(x,y,1.3,2.1,0.6,0.3,time);
   //a=a+makePoint(x,y,1.8,1.7,0.5,0.4,time);   
   
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
   
   
   vec3 d=vec3(a,b,c)/(nc*8.0);
   
   gl_FragColor = vec4(d.x,d.y,d.z,1.0);
}