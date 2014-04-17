#ifdef GL_ES
precision mediump float;
#endif
uniform float time;
uniform vec2 resolution;
void main( void ) {
  vec3 lightblue = vec3(.1,.2,.8);
  vec3 orange = vec3(.6,.4,.1);
  vec2 position = ( gl_FragCoord.xy / resolution.xy );
  float oss = cos(time);
  vec3 xcolor = mix(orange, lightblue, oss*position.x);
  vec3 ycolor = mix(lightblue, orange, oss*position.y);	
  gl_FragColor = vec4(xcolor+ycolor, 1.0);
}