precision mediump float;

uniform float time;
uniform vec2 resolution;

float wave(vec2 p, float angle) {
  vec2 direction = vec2(sin(angle), cos(angle));
  return atan(dot(p, direction));
}

float wrap(float x) {
  return abs(mod(x, 2.) - 1.);
}

void main() {
  vec2 position = (gl_FragCoord.xy / resolution.xy);
  vec2 p = (position - .5) * 100.0;

  float brightness = 0.;
  for (float i = 1.; i <= 2.; i++) {
    brightness += wave(p, time / i);
  }

  brightness = wrap(brightness);

  gl_FragColor = vec4(brightness, brightness, brightness, 1.0);
}