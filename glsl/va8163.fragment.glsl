#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float random(vec3 i)
{
  vec2 n = i.xy * (2.0/i.z);
  return 0.5 + 0.5 * fract(sin(dot(n.xy, vec2(12.9898, 78.233)))* 43758.5453) * 1.;
}

void main(void)
{
        vec2 uv = gl_FragCoord.xy / resolution.xy;
        float c = random(vec3(uv.xy, sin(time)));
        c = clamp(c - 0.6, 0.0, 1.0);

        gl_FragColor = vec4(vec3(c), 1.);
}
