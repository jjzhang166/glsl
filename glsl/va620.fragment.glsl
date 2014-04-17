// By @ToBSn
// Roof

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float make(vec2 p, float r, float sx, float sy) {
  float xx = tan( p.x) * sx * cos(r);
  float yy = fract( p.y) * sy;
  return 1.0/sqrt(xx * xx * yy + yy) * distance(sy, sx);
}
void main( void )
 {

   vec2 p = (gl_FragCoord.xy/resolution.x)*2.0-vec2(1.0,resolution.y/resolution.x);
   p *= 25.;
   float b = 0.0;
   b += make(p, .7, 0.8, 0.2);
   b *= 0.075;
   
   gl_FragColor = vec4(b*6.0,b,b,1.0);
}