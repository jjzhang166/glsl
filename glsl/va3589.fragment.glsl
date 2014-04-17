#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
void main( void ) {

  vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;
  float red = 0.1;
  float green = 0.1 + sin(position.x) * 1.25;
  float blue = 0.6;
  vec3 rgb = vec3(red, green, blue);
  vec4 color = vec4(rgb, 1);
  gl_FragColor = color;
  
}