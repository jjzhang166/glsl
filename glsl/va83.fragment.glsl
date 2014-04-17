// Oldskool effect by Log (Amiga rulez !!! :)

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
  vec2 position = ( gl_FragCoord.xy / resolution.xy );
  vec3 color = vec3(0.1, 0.1, 0.3);
  float PI = 3.14159265358979323846264;

  float bgo = 0.5 + (0.05 * sin(time) * cos(time * position.y / 200.0));
  float bgr = 0.35 + (0.08 * cos(time) * sin(time / position.x / 200.0));
  if (position.x > ( bgo - bgr ) && position.x < (bgo + bgr)) {
    color = vec3(0.2, 0.2, 0.4);
  }

  float r = 0.15;
  float a = time + (0.5 + 1.5 * cos(time)) * position.y;
  float o = 0.5;
  float d = PI / 4.0;
  for (int i = 0; i < 9; i++) {
    if (position.x > (o + r * cos(a)) && position.x <= (o + r * cos(a + d)) ) {
      float b = cos(a + PI / 2.0);
      color = vec3(0.3 + b*0.5, 0.3 + b*0.5, b*0.5);
      break;
    }
    a += d;
  }

  gl_FragColor = vec4(color, 1.0);
}