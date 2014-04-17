#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;
 
void main() {
  float pos = (gl_FragCoord.y) / resolution.y;
 
  gl_FragColor = vec4(gl_FragCoord.x, pos, 0.0, 1.0);
}