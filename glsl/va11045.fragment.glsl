#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define COORDINATE_SYSTEM_WIDTH 2.0
#define ITERATION_LIMIT 1000

vec4 color(float x);

void main (void)
{
	vec2 z, c;
	c.x = 2.0 * gl_FragCoord.x/resolution.x - 1.2;
	c.y = 2.0 * gl_FragCoord.y/resolution.y - 1.0;
	c.x *= COORDINATE_SYSTEM_WIDTH;
	c.y *= COORDINATE_SYSTEM_WIDTH * resolution.y/resolution.x;
	
	z = vec2(0.0);
	
	float dist_sum = 0.0;
	
	for (int i=0; i<ITERATION_LIMIT; i++)
	{
		z = vec2(z.x*z.x - z.y*z.y, 2.0*z.x*z.y);
		z += c;
		if (length(z) > 2.0)
		{
			
			gl_FragColor = color(length(z)/float(i));
			return;
		}
	}
	gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
}

vec4 color(float x)
{
	float t = mod(time, 5.0)*0.2;
	if (t <= 2.5*0.2)
	{
		return vec4(0.0, t*1.0-x, x, 1.0);
	}
	else
	{
		return vec4(0.0, (1.0-t)*1.0-x, x, 1.0);
	}	
	
}