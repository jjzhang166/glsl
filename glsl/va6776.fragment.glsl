#ifdef GL_ES
precision highp float;
#endif

      uniform vec4 insideColor;
      uniform sampler2D outsideColorTable;
      uniform int numIterations;

      const vec2 scale = vec2(4.0, 2.0);
      const vec2 center = vec2(0.5, 0.0);

      void main(void) {
        vec2 c = gl_FragCoord.xy / vec2(512.0, 256.0);
        c = vec2((c.x - 0.5) * scale.x - center.x, (c.y - 0.5) * scale.y - center.y);

        vec4 z = vec4(c.xy, 0.0, 0.0);
        for (int i = 0; i < 1000; i++) {
          if (i > numIterations) break;

          z.z = float(i);

          z.xy = vec2(z.x * z.x - z.y * z.y, 2.0 * z.x * z.y) + c;
          if (dot(z.xy, z.xy) > 4.0) {
            z.w = 1.0;
            break;
          }
        }

        if (z.w > 0.0) {
          gl_FragColor = texture2D(outsideColorTable, vec2(z.z / float(numIterations), 0.0));
        }
        else
          gl_FragColor = insideColor;
      }
