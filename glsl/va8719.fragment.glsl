// By @paulofalcao
//
// More blobs modifications :)

// Slow mod mkjpboffi

// mix & smoothstep mod by anon

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


float makePoint(float x,float y,float fx,float fy,float sx,float sy,float t){
   float anglex = tan(t*fx)*sx;
   float angley = tan(t*fy)*sy;
   float xx=x+anglex;
   float yy=y-angley;
   float xx0=x*2.0+anglex;
   float yy0=y*2.0-angley;
   float a=0.5/sqrt(abs(x*xx)+abs(y*yy));
   float b=0.5/sqrt(x*xx+y*yy);
   float c=xx0*anglex - yy0*angley;
   float f = 1.0-smoothstep(0.0, 0.5, c);
   float color = mix(a*b, 0.0, f);
   return mix(color, 0.0, smoothstep(0.0, 0.5, x*x+y*y));
}

void main( void ) {
   vec2 p = gl_FragCoord.xy/resolution.xy;
   p=-1.0+p*2.0;
   p.x*=resolution.x/resolution.y;
   
   float x=p.x;
   float y=p.y;
   
   float t=time*0.15;

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
   
   gl_FragColor = vec4(d.x,d.y,d.z,(d.x+d.y+d.z)/3.0);
}
	
