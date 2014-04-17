// By @ToBSn
//

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float rows = 25.;

float make(vec2 p, float r, float sx, float sy, float t) {
  float xx = tan(t * p.x) * sx * cos(r);
  float yy = sin(t * p.y) * sy * sin(r);
  return 1.0/sqrt(xx * xx * yy + yy) * distance(sy, sx);
}
void main( void )
 {

   vec2 p=(gl_FragCoord.xy/resolution.x)*2.0-vec2(1.0,resolution.y/resolution.x);

   float b = 0.0;
   b += make(p, -8., 1.0, 1.0, rows);
   b += make(p, .12, 0.8, 0.1, -rows);
   b *= 0.075;
   
   gl_FragColor = vec4(b,b,b,1.0);
}