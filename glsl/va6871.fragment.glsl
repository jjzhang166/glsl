  // Original by MISTY LIGHTS by WEYLAND YUTANI
  // Fork by Vandroiy
  // Simplified the shader to have only one ball, and to follow the mouse

  #ifdef GL_ES
  precision highp float;
  #endif
  uniform vec2 mouse;
  uniform vec2 resolution;
  uniform float time;
  
float size=10.0;

  void main(void)
  {
    vec2 move1;
    move1.x = mouse.x;
    move1.y = mouse.y;
 
    vec2 p = gl_FragCoord.xy / resolution.xy;
    float r1 =(dot(p-move1,p-move1))*150.0*size;
  
    float metaball =(1.0/r1);
    gl_FragColor = vec4((pow(metaball,1.0+move1.x),pow(metaball,1.0),pow(metaball,1.0))
    -mix(vec3(0.2+cos(time/2.5)/5.0, 0.2+sin(time/3.5)/5.0, 0.2+sin(time/3.0)/5.0),vec3(0.0), p.y),1.0);
  }