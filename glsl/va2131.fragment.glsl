#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

float GetCell(vec2 pos)
{
	return texture2D(backbuffer, pos / resolution).g;
}

void main( void )
{
	if(false)
	{
		gl_FragColor = vec4(0.0);
	}
	else
	{
		if(gl_FragCoord.x == 1921.0 / 2.0 && gl_FragCoord.y == 1000.5)
		{
			gl_FragColor = vec4(0.0, 0.6, 0.0, 1.0);
		}
		else if(true)
		{
			if(fract(GetCell(gl_FragCoord.xy + vec2(-1, 1)) + GetCell(gl_FragCoord.xy + vec2(1, 1))) > 0.5)
			{
				gl_FragColor = vec4(0.0, 0.6, 0.0, 1.0);
			}
			else
			{
				gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
			}
		}
	}
}