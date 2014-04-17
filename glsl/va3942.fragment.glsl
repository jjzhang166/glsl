#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

 vec2 pos = mod(gl_FragCoord.xy, vec2(50.0, 50.0)) - vec2(25.0, 25.0);
      float dist_squared = dot(pos, pos);
 vec2 distance = abs(mouse * resolution - gl_FragCoord.xy) * vec2(10.0);
 
 gl_FragColor = (dist_squared < 400.0) 
          ? vec4(.90 - distance.x, .90 - distance.y, .90, 1.0)
          : vec4(0);
}