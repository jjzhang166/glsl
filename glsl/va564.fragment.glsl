#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//rotation
vec2 rotate(vec2 k, float t) {
  return vec2(cos(t)*k.x - sin(t)*k.y, sin(t)*k.x + cos(t)*k.y);
}

//ksm
float qk(vec3 p, float k) {
  return sin(p.x * k) +sin(p.y * k) +sin(p.z * k);
}

float road(vec3 p) {
  
  //rotate angle
  p.xy = rotate(p.xy, (mouse.x - 0.5) * 2.5);
  vec3 d = abs( mod(p.xyz, 0.2)) - 0.1;
  vec3 d5 = abs( mod(p.xyz, 50.0)) - 25.0;
  vec3 d8 = abs( mod(p.xyz, 200.0)) - 100.0;
  
  
  //road
  float t1 = length(p.xy) - 1.0;
  
  //road hole
  float t2 = length(d) - 0.11;
  
  //ground
  float t3 = dot(p, vec3(0.0, 1.0, 0.0)) + 2.0 + (sin(p.x) * sin(p.z)) * 0.5;
  float t7 = dot(p, vec3(0.0, -1.0, 0.0)) + 80.0 + (sin(p.x) * sin(p.z)) * 0.5;
  
  //poll
  float t4 = length(d5.xz) - 0.1;
  
  //big poll
  float t5 = length(d8.xz) - 50.0;
  
  
  //merge
  float g = max(t7, t5);
  g = min(min(t4, min(t3, max(t1, -t2))), g);
  return g;
}

void main( void ) {
  vec2 position = ( gl_FragCoord.xy / resolution.xy );
  vec2 uv = -1.0 + 2.0 * position;
  vec3 dir = normalize(vec3(uv * vec2(1.25, 1.0), 1.0));
  
  //pitch
  dir.yz = rotate(dir.yz, (mouse.y - 0.35) * 5.0);

  //pos
  vec3 pos = vec3(sin(time * 0.4), 2.2 + cos(time * 0.4) * 0.3, time * 30.7 + sin(time));
  vec3 ray = pos;
  float  t = 0.0;
  
  //raycast
  for(int i = 0 ; i < 150; i++) {
    float k = road(ray + dir * t);
    t += k * 0.95;
  }
  vec3 hit = ray + dir * t;
  vec2 h   = vec2(0.01, 0.00);

  vec3 N   = normalize(vec3(
    road(hit + h.xyy),
    road(hit + h.yxy),
    road(hit + h.yyx)) - road(hit));
  vec3 L = normalize(vec3(-1.0, 1.1, 0.5));
  float D = max(dot(N, L), 0.0);
  
  //output color
  vec4 col = mix(vec4(1, 2, 3, 1) * 0.5, vec4(2, 1.5, 1, 1), t * 0.01) * 0.07;
  float fog = t * 0.001;
  gl_FragColor = vec4(col.xyz + D + dir.yzx * 0.1, 1) + fog;
}


//gyabo
