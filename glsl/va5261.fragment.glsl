// By @paulofalcao
//
// Blobs

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float makePoint(float x,float y,float fx,float fy,float sx,float sy,float t)
{
   float xx = x + cos(t * fx) * sx;
   float yy = y + sin(t * fy) * sy;
   return 1.0/sqrt(xx * xx + yy * yy);
}

void main( void ) 
{

   vec2 p=(gl_FragCoord.xy/resolution.x)*2.0-vec2(1.0,resolution.y/resolution.x);

   p=p*2.0;
   p = (gl_FragCoord.xy / resolution.xy) * 2.0 - vec2(1.0,1.0);
   
   float x=p.x;
   float y=p.y;

   float c = makePoint(x,y,0.0,0.0,0.0,0.0,0.0);
   
   vec3 d = vec3(0.0,0.0,c);// / 32.0;
   
   gl_FragColor = vec4(d.x,d.y,d.z,1.0);
}