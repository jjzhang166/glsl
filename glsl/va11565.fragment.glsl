#ifdef GL_ES
precision highp float;
#endif
 
uniform vec2 resolution;
uniform float time;
 
void main(void)
{
  // Be Cool
  vec2 p = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
  float r = length(p);
 
  float b = sin(10.*r - time*4. - 5. * r);
  b *= smoothstep(0.5, 0.2, r);
 
  gl_FragColor = vec4(b, 0.67 * b, 0.0, 1.0);
}