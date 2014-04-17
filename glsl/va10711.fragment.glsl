precision mediump float;

varying vec2 surfacePosition;
uniform float time;

// war of the ants, i vote for the black ones
float random(float p) {
  return fract(sin(fract(tan(p)))*12345.);
}

float noise(vec2 p) {
  return random(mod(asin(-2.0+time)/(p.x*p.x)+p.y, fract(acos(-1.0+time)/(p.y*p.y)+p.x)));
}

void main() {
  vec2 p = surfacePosition;
  gl_FragColor.rgb = vec3(noise(p*time+304.0));
  gl_FragColor.a = 1.;
}