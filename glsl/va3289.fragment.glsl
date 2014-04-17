#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void		main(void)
{
	float r, g, b;
	
	vec2 c, z;
	
	/* Julia set */
	/* For Mandelbrot, z1 = vec2(0.0, 0.0) and c = Julia's z */
	c.x = mouse.x;
	c.y = mouse.y;
	z = ((gl_FragCoord.xy / resolution.xy) - 0.5) * 4.0;
	z.x *= (resolution.x / resolution.y);
	
	gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
	
	for (float i = 0.0; i < 64.0; i += 1.0)
	{
		float x = ((z.x * z.x) - (z.y * z.y)) + c.x;
		float y = ((z.y * z.x) + (z.x * z.y)) + c.y;
	        if (((x * x) + (y * y)) > 4.0)
		{
			gl_FragColor.g = gl_FragColor.b = 0.5 + (i / 64.0);
			break;
		}
        	z.x = x;
        	z.y = y;
	}
}