#ifdef GL_ES
precision mediump float;
#endif

uniform float pixelAmount;
uniform vec2 resolution;
uniform sampler2D backbuffer;
uniform float time;

void main(void) {
  vec2 uv = gl_FragCoord.xy / resolution.xy;
  vec2 divs = vec2(resolution.xy / time);
  uv = floor(uv * divs)/ divs;
  gl_FragColor = texture2D(backbuffer, uv);
}