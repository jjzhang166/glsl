#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define M_PI 3.14159265358979323846
//old ass learning glsl type shader from somewhere. Pretty generic and universal way of making a circle though. Softened it up, changed some stuff. -gtoledo  
//uniform float size;
  void main(void)
 {
      vec2 pos = (mod(1. * gl_FragCoord.xy-(mouse*resolution.x), vec2(50.0)) - vec2(25.0));
      float dist_squared = dot(pos, pos);
  
     gl_FragColor = mix(vec4(.90, .90, .90, 1.0), vec4(0.0, 0.0, 0.0, 1.0),
                        smoothstep(1.0, resolution.x/2., dist_squared));
 }

