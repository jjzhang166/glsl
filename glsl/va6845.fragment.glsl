 
#ifdef GL_ES
precision highp float;
#endif

#define PI 3.1415926535

uniform float time;
uniform vec2 resolution;

const int k = 12;
const vec3 color = vec3(0.53, 0.33, 0.65);
const float speed = 2.0;
const float scale = 60.0;

float sawtooth(float x) {
  return mod(x / PI, 2.) - 1.;
}

float solarize(float val) {
  return mod(floor(val), 2.0) == 0.0 ? fract(val) : 1.0 - fract(val);
}

void main(void) {
  const float step = PI / float(k);
  float angle = 0.0;
  float ans = 0.0;

  vec2 defpixel = (gl_FragCoord.xy - resolution / 2.0) / resolution.y * scale;
  for (int i = 0; i < k; i++) {
    float s = sin(angle);
    float c = cos(angle);
    ans += (sawtooth(c * defpixel.x + s * defpixel.y + speed * time) + 1.0) / 2.0;
    angle += step;
  }

  const float gamma = 5.0;
  //ans = exp(log(solarize(ans / float(k) * 2.0)) * gamma);
   ans /= float(k);

  gl_FragColor = vec4(color * ans, 1.0);
}
