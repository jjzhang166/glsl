// by @h013

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;
uniform vec2 mouse;
uniform float time;
//trippyfied by uitham!
vec4 hsv2rgb(vec3 col)
{
    float iH = floor(mod(col.x,1.0)*6.0);
    float fH = mod(col.x,1.0)*6.0-iH;
    float p = col.z*(1.0-col.y);
    float q = col.z*(1.0-fH*col.y);
    float t = col.z*(1.0-(1.0-fH)*col.y);
  
  if (iH==0.0)
  {
    return vec4(col.z, t, p, 1.0);
  }
  if (iH==1.0)
  {
    return vec4(q, col.z, p, 1.0);
  }
  if (iH==2.0)
  {
    return vec4(p, col.z, t, 1.0);
  }
  if (iH==3.0)
  {
    return vec4(p, q, col.z, 1.0);
  }
  if (iH==4.0)
  {
    return vec4(t, p, col.z, 1.0);
  }
  
  return vec4(col.z, p, q, 1.0); 
}
void main(void) {
  vec2 pos = vec2(0.5, 0.5) - gl_FragCoord.xy / resolution.xy;
  
  pos.y *= resolution.y / resolution.x;
  float R = 0.2;
  float theta = acos(-pos.y / R);
  float phi = asin(pos.x / sin(theta) / R);
  theta += mouse.y * 3.14 - 3.14;
  phi += mouse.x * 3.14 - 1.57;
  
  vec2 p = vec2(0.4, 0.25 * sin(time));  
  vec2 z = vec2(theta, phi);
  int c = 0;
  for (int i = 0; i < 32; i ++) {
    if (length(pos) > R || length(z) > 2.0) break;
    z = vec2(z.x * z.x - z.y * z.y, 2.0 * z.x * z.y) + p;
    c ++;
  }
  float r = float(c) / 32.0;
  gl_FragColor = hsv2rgb(sin(vec3(r/4.0, r/2.0, r) + time) + 1.0);  
}
