#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

#define PRED(p) ((p.x - 0.5) * (p.x - 0.5) + (p.y - 0.5) * (p.y - 0.5) > 0.1)

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	
	if(position.x < 0.015 && mod(time,1.0) < 0.02)
		gl_FragColor = vec4(position.x * 100.0 - 0.5, 0.0, 1.0, 1.0);
	else
	{
		vec2 s = texture2D(backbuffer, position).rb;
		{
			const float st = 3.14159265 / 36.0;
			float g = 2.0, gf = 0.0;
			float wl = 0.005;
				
			if(PRED(position))
				wl = 0.002;
			
			for (float f = 0.0; f < 3.14159265; f += st)
			{
				vec2 cd =  position + vec2(cos(f), sin(f)) * wl;
				if(!PRED(cd) || PRED(position))
				{
					vec3 c = texture2D(backbuffer,cd).rgb;
					if (c.b > 0.99 )
					{
						if(c.r < g && (c.r < s.r || (s.y < 0.1 && c.r > s.r)))
						{
							g = c.r;
							gf = f;
						}
					}
				}
			}

			gl_FragColor = (g < 1.5) ? vec4(g, gf / 3.141, 1.0, 1.0) : vec4(0.0, 0.0, 0.0, 1.0);	
			
			
			
		}
	}
	
	if(mouse.x < 0.1)
		gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);

}