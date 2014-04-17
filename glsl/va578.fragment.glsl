// By @ToBSn
// Wait a minute

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float make(vec2 p, float r, float sx, float sy, float t) {
  float xx = cos(sx + t) + length(p.x * t) + sin( r );
  float yy = sin(sy + t) + length(p.y * t) + cos( r );
  return 1.0/(sqrt(xx * tan(yy * sx)) * dot(sx, sx) + distance(sy, sy));
}
void main( void )
 {

   vec2 p=(gl_FragCoord.xy/resolution.x)*2.0-vec2(1.0,resolution.y/resolution.x);
   
   float t = time * .025;
     
   float a = 0.5;
 // a += make(p, .2, .1, 0.8, -t);
   a += make(p * t, .4, .8, 0.1, t);
   
   float b = 0.5;
  // b += make(p * t, .8, .1, 0.8, t);
   b += make(p, .12, .8, 0.1, -t);
   
   float c = 0.5;
 //  c += make(p, .8, .1, 0.8, t);
   c += make(p * t, .12, .8, 0.1, -t);
   
   vec3 d=vec3(a,b,c) * .25;
   
   gl_FragColor = vec4(d.x,d.y,d.z,1.0);
}