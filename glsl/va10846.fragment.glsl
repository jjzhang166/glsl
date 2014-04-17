#ifdef GL_ES
precision mediump float;
#endif

varying vec2 position;
uniform sampler2D webcam;

float wave(float x, float amount) {
  return (sin(x * amount) + 1.) * .5;
}

void main() {
  vec4 color = texture2D(webcam, position);
  gl_FragColor.r = wave(color.r, 10.);
  gl_FragColor.g = wave(color.g, 10.);
  gl_FragColor.b = wave(color.b, 30.);
  gl_FragColor.a = 1.;
}