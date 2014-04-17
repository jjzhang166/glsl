#ifdef GL_ES
precision mediump float;
#endif

uniform sampler2D optTex;
uniform vec2 resolution;
uniform float time;

float aspect;
float width = 1.0 / 100.0;
float width_border = 1.0 / 800.0;

vec2 center = vec2(0.5, 0.5);
vec4 color1 = vec4(0.2, 0.2, 1.0, 1.0);
vec4 color2 = vec4(0.6, 0.6, 1.0, 1.0);
vec4 color3 = vec4(1.0, 1.0, 1.0, 1.0);
int count = 0;

void main() {
  vec2 pos = gl_FragCoord.xy / resolution.xy;
  aspect = resolution.y / resolution.x;
  vec4 color;
  float zoom = 0.5 + sin(time) * 0.4;
  vec2 z = vec2(zoom, aspect * zoom);
  float angle = fract(time * 0.05) * 3.14159265;
  float co = cos(angle);
  float si = sin(angle);

  mat3 rotation = mat3(z.x * co, -z.y * si, 0.0,
                       z.x * si,  z.y * co, 0.0,
                            0.0,       0.0, 1.0
                  );
  vec3 uv = vec3(pos.x - center.x, pos.y - center.y, 1.0) * rotation;

//vertical
  if(mod(floor(uv.x / width), 2.0) == 0.0){
    count = count + 1;
  }
  
//horizontal
  if(mod(floor(uv.y / width), 2.0) == 0.0){
    count = count + 1;
  }

  if(count == 0){
    color = color1;
  } else {
    if(count == 1){
      color = color2;
    } else {
      color = color3;
    }
  }
  gl_FragColor = color;
}
