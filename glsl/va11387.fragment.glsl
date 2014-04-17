  precision highp float;
  varying vec2 v_texcoord;
  uniform lowp sampler2D s_texture;

  const highp vec3 W = vec3(0.2125, 0.7154, 0.0721);
  const vec3 ctable[4] = vec3[]( vec3(  0.0,  50.0,  77.0) / 255.0, //dark blue
                                 vec3(224.0,  24.0,  37.0) / 255.0, //red
                                 vec3(116.0, 152.0, 164.0) / 255.0, // light blue
                                 vec3(253.0, 229.0, 169.0) / 255.0 // light yellow
                               );
  const float steps[4] = float[]( 0.0, 0.3, 0.5, 0.6);
  void main() {
    vec4 color = texture2D(s_texture, v_texcoord);
    float intensity = dot(color.xyz, W);
    vec3 c;
    for(int i = 0; i < 4; i++) {
      if(intensity >= steps[i]) {
        c = ctable[i];
      }
    }
    gl_FragColor = vec4(1.0, c.x, c.y, c.z);
  }