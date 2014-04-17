#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;
 
float lengthN(vec2 v, float n)
{
  vec2 tmp = pow(abs(v)*sin(time), vec2(n));
  return pow(tmp.x*tmp.y, 1.0/n);
}
 
float rings(vec2 p)
{
  vec2 p2 = mod(p*15.0, 4.0)-2.0;
  return sin(lengthN(p2, 4.0)*16.0);
}
 
vec2 trans(vec2 p)
{
  float sec;
  sec = time*1.016;
  return vec2(p.x+cos(sec), p.y+sin(sec));
}
 
void main() {
  vec2 pos = (gl_FragCoord.xy*2.0 -resolution) / resolution.y;
  vec2 uv  = -1.0 + 2.0 * (gl_FragCoord.xy/resolution.xy);
  vec3 D   = vec3(uv.x * 1.25, uv.y, sin(time));
  vec3 p   = vec3(time * 2.0, 0, time * 3.0);
  vec3 g   = p;
  for(int i = 0 ; i < 40; i++) {
    float k = 3.0 - dot(abs(g), vec3(0, 1, 0)) + sin(g.y) + sin(g.x)*cos(g.y);
    g += D * k * 0.5;
  }
  float c = length(g - p) * 0.03;
  gl_FragColor = vec4(rings(trans(g.xz * 0.2)),0.4,0.4,0.2) + c*sin(time);
}
