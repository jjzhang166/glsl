// by @h013

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;
uniform vec2 mouse;
uniform float time;

void main(void) {
  vec2 pos = vec2(0.5, 0.5) - gl_FragCoord.xy / resolution.xy;
  
  pos.y *= resolution.y / resolution.x;
  float R = 0.2;
  float theta = acos(pos.y / R);
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
  gl_FragColor = vec4(r/4.0, r/2.0, r, 1.0);  
}
