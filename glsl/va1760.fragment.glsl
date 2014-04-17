#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;

void main(void){
  gl_FragColor=vec4(0,0,0,1); //background color
}