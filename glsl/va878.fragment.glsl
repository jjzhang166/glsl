// Noise from http://www.ozone3d.net/blogs/lab/20110427/glsl-random-generator/ 
// adapted by @hintz

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rand(vec2 n)
{
  return fract(sin(dot(n.xy, vec2(12.9898, 78.233)))*43758.5453);
}

void main(void)
{
  float x = rand(gl_FragCoord.xy+mouse*time);

  gl_FragColor = vec4(x, x, x, 1.0);
}