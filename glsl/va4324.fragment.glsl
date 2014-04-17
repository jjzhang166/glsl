#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

varying vec3 v;
float rand(vec2 n)
{
  return 0.5 + 0.5 * 
     fract(sin(dot(n.xy, vec2(12.9898, 78.233)))* 43758.5453);
}
void main(void)
{
  float x = rand( clamp( mouse*gl_FragCoord.xy,0.0,22.5) );
  gl_FragColor = vec4(x, x, x, 1.0);
}