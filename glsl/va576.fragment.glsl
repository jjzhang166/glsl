// By @ToBSn
//

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float make(vec2 p, float r, float sx, float sy, float t) {
  float xx = tan(t * p.x) * sx * cos(r);
  float yy = tan(t * p.y) * sy * sin(r);
  return 1.0/sqrt(xx * xx + yy + yy) * distance(sx, sy);
}
void main( void )
 {

   vec2 p=(gl_FragCoord.xy/resolution.x)*2.0-vec2(1.0,resolution.y/resolution.x);
   
   float t = time * .025;
     
   float a = 0.0;
   a += make(p * time, .2, 0.1, 0.8, t);
   a += make(p , .4, 0.8, 0.1, t);
   
   float b = 0.0;
   b += make(p * time, .8, 0.1, 0.8, t);
   b += make(p, .12, 0.8, 0.1, t);
   
   float c = 0.0;
   c += make(p * time, .8, 0.1, 0.8, t);
   c += make(p, .12, 0.8, 0.1, t);
   
   vec3 d=vec3(a,b,c) * 0.05;
   
   gl_FragColor = vec4(d.x,d.y,d.z,1.0);
}