  // MISTY LIGHTS by WEYLAND YUTANI, simplified to two blobs by @danbri

  #ifdef GL_ES
  precision highp float;
  #endif
  uniform vec2 mouse;
  uniform vec2 resolution;
  uniform float time;
  float size = 0.9;
  float foo=1.5;
  float bar=2.;
  float blob1size=10.;
  float blob2size=530.;

  void main(void)
  {

    vec2 move1,move2;
    move1.x = cos(time*foo)*size;
    move1.y = sin(time*bar)*size;

    move2.x = cos(time*foo)*size;
    move2.y = sin(time*bar)*size;

    vec2 p = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;

    float r1 =(dot(p-move1,p-move1)) * blob1size;
    float r2 =(dot(p+move2,p+move2)) * blob2size;

    float metaball = 1./r1 + 1./r2;
    metaball = 1./r2;

    gl_FragColor = vec4( pow(metaball,1.0), 0, 0, 0 );

  }