precision mediump float;

varying vec2 position;

float random(float p) {
  return fract(sin(p)*10000.);
}

float noise(vec2 p) {
  return random(p.x + p.y*10000.);
}

void main() {
  vec2 p = position;
  float brightness = noise(p);
  gl_FragColor.rgb = vec3(brightness);
  gl_FragColor.a = 1.;
}