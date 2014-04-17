#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 scene1(void) {
  vec2 p = (gl_FragCoord.xy / resolution.xy - vec2(0.5, 0.5)) * 2.0;
  float x = mod(p.x * 10.0, 1.0);
  return vec3(x, p.y, 0.0);
}

vec3 scene2(void) {
  vec2 p = (gl_FragCoord.xy / resolution.xy - vec2(0.5, 0.5)) * 2.0;
  float y = mod(p.y * 10.0, 1.0);
  return vec3(0.0, -p.x, y);
}

void main( void ) {
  float t = mod(time, 5.0) / 5.0;
  gl_FragColor.rgb = scene1();
  gl_FragColor.rgb = scene2();
  gl_FragColor.rgb = scene1() * (1.0 - t) + scene2() * t;
  gl_FragColor.a = 1.0;
}
