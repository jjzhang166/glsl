#ifdef GL_ES
precision mediump float;
#endif


uniform vec2 resolution;
uniform float time;
uniform sampler2D backbuffer;
 
void main() {
  vec2 pos = (gl_FragCoord.xy*2.0 -resolution) / resolution.y;
 
  float theta = time*0.50;
  vec2 ballPos = vec2(cos(theta), sin(theta))*0.5;
  vec2 texPos = vec2(gl_FragCoord.xy/resolution);
 
  if(distance(pos, ballPos) < (0.2 * ((sin(time)/2.0)+0.75)))
  {
    gl_FragColor = vec4(sin(time)+ 1.0, (cos(time*0.5)/2.0) + 0.5, 0.0, 1.0);
  }else
  {
    gl_FragColor = texture2D(backbuffer, texPos)*.95;
  }
}