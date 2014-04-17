precision mediump float;

varying vec2 surfacePosition;
uniform float time;

float random(float p) {
  return fract(sin(p)*10000.);
}

float noise(vec2 p) {
  return random(p.x + p.y*112.5345);
}

void main() {
  vec2 p = surfacePosition;
  gl_FragColor.rgb = vec3(noise(p*time+304.0), noise(p*time+45.0), noise(p*time+5344.0));
  gl_FragColor.a = 1.;
}