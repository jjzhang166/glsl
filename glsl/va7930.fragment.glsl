#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float random(in vec3 i)
{
  vec2 n = i.xy * (2.0/i.z);
  return 0.5 + 0.5 *
     fract(sin(dot(n.xy, vec2(12.9898, 78.233)))* 43758.5453);
}

#define PI2 6.2831853071

float wave(
        in vec2 p, // uv
        in float w, // width
        in float a, in float b, in float c, in float d
) {
        float v = (cos(p.x * PI2 * a + b) * c + d) / 2.0 + 0.5;
        if(v + w > p.y && v - w < p.y)
                return 1.0;
        else
                return 0.0;
}


void main(void)
{
        vec2 uv = gl_FragCoord.xy / resolution.xy;
        float c = random(
                        vec3(uv.xy, sin(time))
                );
        c = clamp(c - 0.6, 0.0, 1.0);

        float w = 0.0;

        w = wave(
                uv,
                0.02,
                3.0, time, 0.1 + 0.25 * sin(time * 9.0), 0.0
        );

        w = max(w,
                        wave(
                                uv,
                                0.03,
                                3.0, time * 3.0, 0.1, 0.7
        ));
        w = max(w,
                        wave(
                                uv,
                                0.03,
                                3.0, time * 3.0, 0.1, -0.7
        ));

        c = max(c, w);

        gl_FragColor = vec4(
                c, c, c, 1.0
        );
}
