#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
  vec2 p = (gl_FragCoord.xy / resolution.x - vec2(0.5, 0.5 * resolution.y / resolution.x)) * 2.0;

  float t = mod(time, 3.0);

  float d = p.x * p.x + p.y * p.y;

  float c = 0.0;
  if (t < 0.5) {
    float e = (d - (0.5 - t) * 4.0) * 5.0;
    if (e > 0.0) {
      c = 1.0 / e / e;
    }
    c += t;
  } else if (t < 0.75) {
    c = (t - 0.25) * 2.6;
  } else if (t < 1.25) {
    t -= 0.25;
    float e = (d - (t - 0.5) * 4.0) * 5.0;
    if (e < 0.0) {
      c = 1.0 / e / e;
    }
    c += 1.0 - t;
  }

  float x = p.x * p.x;
  float y = p.y * p.y;
  float r = sin(x) * cos(y) * x * 0.2;

  gl_FragColor.a = 1.0;
  gl_FragColor.rgb = vec3(c, c - r * 2.0, c - r);
}
