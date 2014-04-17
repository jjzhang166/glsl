#ifdef GL_ES
precision mediump float;
#endif

uniform sampler2D optTex;
uniform vec2 resolution;
uniform float time;

float aspect;
float num_horizontal;
vec4 color_bg1 = vec4(0.9, 0.9, 1.0, 1.0);
vec4 color_bg2 = vec4(0.4, 0.4, 1.0, 1.0);
vec4 color_fg = vec4(0.3, 0.3, 1.0, 1.0);
vec2 grid;
vec2 point;
float r;
vec2 center = vec2(0.5, 0.5);

int IsInAspectCircle(vec2 pos, vec2 point){
  vec2 aspectpos = (pos - point) * vec2(1.0, aspect);
  if(distance(aspectpos, vec2(0.0, 0.0)) < r) return 1;
  return 0;
}

vec4 getColor(vec2 pos){
  if(IsInAspectCircle(pos, point) == 1) return color_fg;
  if(IsInAspectCircle(pos, point + grid) == 1) return color_fg;
  if(IsInAspectCircle(pos, point - grid) == 1) return color_fg;
  if(IsInAspectCircle(pos, point + grid * vec2(1.0, -1.0)) == 1) return color_fg;
  if(IsInAspectCircle(pos, point + grid * vec2(-1.0, 1.0)) == 1) return color_fg;
  return mix(color_bg1, color_bg2, pos.x);
}

void main() {
  vec2 pos = gl_FragCoord.xy / resolution.xy;
  aspect = resolution.y / resolution.x;
  num_horizontal = 140.0 + sin(time / 4.0) * 100.0;

  vec2 brickCounts = vec2(num_horizontal, num_horizontal * aspect);
  grid = 1.0 / brickCounts;
  r = grid.x * 0.45 * (sin(time * 1.5 + (pos.x + pos.y) * 5.0) * 0.7 + 1.0);

  point = floor(brickCounts * (pos - center)) / brickCounts + grid * 0.5 + center;
  vec2 point_count = floor((point - center) * brickCounts) + center;
  if(mod(point_count.x + point_count.y, 2.0) < 0.00001){
    if(pos.x < point.x){
      point.x -= grid.x;
    } else {
      point.x += grid.x;
    }
  }
  
  gl_FragColor = getColor(pos);
}
