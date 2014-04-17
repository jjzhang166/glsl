// By @paulofalcao
//
// Blobs with nice gradient

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float makePoint(float x,float y,float fx,float fy,float sx,float sy,float t){
   float xx=-x+sin(t*fx)*sx;
   float yy=-y+cos(t*fy)*sy;
   return 1.2/sqrt(xx*xx+yy*yy);
}

vec3 gu(vec4 a,vec4 b,float f){
  return mix(a.xyz,b.xyz,(f-a.w)*(1.0/(b.w-a.w)));
}

vec3 grad(float f){
	vec4 c01=vec4(0.0,0.0,0.0,0.0);
	vec4 c02=vec4(0.4,0.4,0.4,0.0);
	vec4 c03=vec4(1.0,0.1,0.0,0.95);
	vec4 c04=vec4(1.0,1.0,0.0,0.80);
	vec4 c05=vec4(1.0,1.0,1.0,0.00);
	return (f<c02.w)?gu(c01,c02,f):
	(f<c03.w)?gu(c02,c03,f):
	(f<c04.w)?gu(c03,c04,f):
	gu(c04,c05,f);
}

void main( void ) {

   vec2 p=(gl_FragCoord.xy/resolution.x)*2.0-vec2(1.0,resolution.y/resolution.x);

   p=p*3.0;
   
   float x=p.x;
   float y=p.y;

   float a=
       makePoint(x,y,3.5,2.9,0.3,0.3,time);
   a=a+makePoint(x,y,2.1,2.0,0.4,0.4,time);
   a=a+makePoint(x,y,1.0,0.7,0.4,0.5,time);
   a=a+makePoint(x,y,2.7,0.1,0.6,0.3,time);
   a=a+makePoint(x,y,1.0,1.7,0.5,0.4,time);
   a=a+makePoint(x,y,3.1,0.4,0.6,0.3,time);
   a=a+makePoint(x,y,1.1,1.4,0.5,0.5,time);
   a=a+makePoint(x,y,1.1,1.7,0.4,0.4,time);
   a=a+makePoint(x,y,0.9,0.5,0.4,0.5,time);
   a=a+makePoint(x,y,1.8,0.9,0.6,0.3,time);
   a=a+makePoint(x,y,5.7,1.3,0.5,0.4,time);
   a=a+makePoint(x,y,3.5,0.3,0.3,0.5,time);
   a=a+makePoint(x,y,1.9,1.3,0.4,0.4,time);
   a=a+makePoint(x,y,1.1,0.9,0.4,0.5,time);
   a=a+makePoint(x,y,1.5,1.7,0.6,0.5,time);
   a=a+makePoint(x,y,0.5,0.6,0.5,0.4,time);
   a=a+makePoint(x,y,0.5,0.3,0.4,0.5,time);
   a=a+makePoint(x,y,1.9,0.8,0.4,0.5,time);
   a=a+makePoint(x,y,0.5,0.6,0.6,0.3,time);
   a=a+makePoint(x,y,1.5,0.5,0.5,0.4,time);
   
   vec3 a1=grad(a/124.0);
   
   gl_FragColor = vec4(a1.x,a1.y,a1.z,1.0);
}