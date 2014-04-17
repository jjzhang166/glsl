#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

void main(void)
{
	float	line 	= gl_FragCoord.x / resolution.x;
	float	offset	= sin(time);
	float	offset2	= -sin(time);
	
	float	red;
	float	blue;
	
	if (fract(gl_FragCoord.y / 32.0) < 0.5 && fract(gl_FragCoord.x / 32.0) < 0.5)
	{
		if (fract(gl_FragCoord.x / 256.0) > abs(sin(time)))
		{
			red	= 1.0 - (line + offset);
			blue	= (line + offset);
		}
		
		else
		{
			red	= 1.0 - (line + offset2);
			blue	= (line + offset2);
		}
	}
			
	else
	{
		if (fract(gl_FragCoord.x / 256.0) < abs(sin(time)))
		{
			red	= 1.0 - (line + offset);
			blue	= (line + offset);
		}
		
		else
		{
			red	= 1.0 - (line + offset2);
			blue	= (line + offset2);
		}
	}
	
	red	*= 0.25;
	blue	*= 0.25;
	
	gl_FragColor	= vec4(red, 0.0, blue, 1.0);
}