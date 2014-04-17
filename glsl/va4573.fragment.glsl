#ifdef GL_ES
precision lowp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float makePoint(float x,float y,float fx,float fy,float sx,float sy,float t){
   float xx=x+sin(t*fx)*sx;
   float yy=y+cos(t*fy)*sy;
   return 0.1/(xx*xx+yy*yy);
}

void main( void ) {

   vec2 p=(gl_FragCoord.xy/resolution.x)*2.0-vec2(1.0,resolution.y/resolution.x);

   p=p*1.5;
   
   float x=p.x;
   float y=p.y;

   float t = time * .25;

   float a=
       makePoint(x,y,3.3,2.9,0.3,0.3,t);
 

   vec3 d=vec3(a);
   
   gl_FragColor = vec4(d.x,d.y,d.z,1.0);
}