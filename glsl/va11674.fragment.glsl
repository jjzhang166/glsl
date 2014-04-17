#ifdef GL_ES
precision highp float;
#endif
 
uniform vec2 resolution;
uniform float time;
 
void main(void)
{
  // Be Cool
  vec2 p = gl_FragCoord.xy / resolution.xy - .5;
  p.x *= resolution.x / resolution.y;
  float a = atan(p.y, p.x);
  float r = length(p) ;
 
  float b = 0.9 * sin(9.0 * r - 3.0*time - 6.0*a);
  b = 0.4125 / r + cos(19.0 * a + b +10.0) / (350.0 * r);
  b *= smoothstep(0.5, 1.2,b);
 
  gl_FragColor = vec4(b,  b , b , 1);
}