#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
const float PI = 3.14159265358979323846264;

vec2 tocart(vec2 polar) {
   return vec2(polar.x * cos(polar.y), polar.x * sin(polar.y));
}

vec2 topolar(vec2 cart) {
   float r = sqrt(cart.x*cart.x + cart.y*cart.y);
   float alpha = atan(cart.y, cart.x);
   return vec2(r, alpha);
}

vec2 mirror(vec2 line, vec2 point) {
  float r1 = line.x;


  if (r1 < 100.0) {
    vec2 linecenter = tocart(line);
    vec2 cart = tocart(point);
    float dx = cart.x - linecenter.x;
    float dy = cart.y - linecenter.y;
    float r1 = line.x*line.x - 1.0;
    float r2 = dx*dx+dy*dy;
    float rr = r1 / r2;
    float dx2 = dx * rr;
    float dy2 = dy * rr;
    return topolar(linecenter + vec2(dx2,dy2));
  } else {
    return vec2(point.r, -point.y + 2.0 * line.y + PI);
  }
}

void main( void ) {
  vec2 l1 = vec2(1000.0, 0.0);
  vec2 l2 = vec2(1000.0, PI / 8.0);
  vec2 l3 = vec2(sqrt(sqrt(2.0) + 1.0), PI / 2.0);

  vec2 position = ( gl_FragCoord.xy / resolution.y * 2.0 ) - vec2(2.5, 1.0);

  vec2 p = topolar(position);
  float color;
  if (p.x > 1.0) {
    float color = 0.0;
  } else {
    int g2 = 0;
    int k1 = 1;
    for (int i = 0; i < 7; ++i) {
      if (k1 == 0) {
        continue;
      }
      int k = 1;
      for (int j = 1; j < 8; ++j) {
        if (k == 0 || (p.y >= (PI / 2.0)) && (p.y < (PI * 0.75))) {
          k = 0;
        } else {
          g2 = g2 + 1;
          p = mirror(l2, mirror(l1, p));
        }
      }
      vec2 p1 = mirror(l3, p);
      if ((p1.y >= (PI / 2.0)) && (p1.y < (PI * 0.75))) {
        k1 = 0;
      }
      p = p1;
    }
    color = mod(float(g2), 2.0) / 1.0;
//    color = float(g2)/7.0;
  }
  gl_FragColor = vec4( vec3( color, color, color), 3.0);
}