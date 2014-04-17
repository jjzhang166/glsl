#ifdef GL_ES
precision mediump float;
#endif

//http://glsl.heroku.com/e#7485.1 optimized and changed a little bit by logos7@o2.pl

uniform float time;
varying vec2 surfacePosition;

void main(void)
{
	vec2 p = (1.0 + 0.6 * cos(time)) * surfacePosition;
	float e;
	float c;

	for(float i = 0.0; i < 100.0; i++)
	{
		if(e < 10000.0)
		{
			float xx = p.x * p.x;
			float yy = p.y * p.y;
			float xy = xx + yy;
			
			p = vec2(
					2.0*p.x/5.0 + (xx - yy)/3.0/pow(xy, 2.0 + 0.4 * sin(time)),
					2.0*p.y/3.0 * (1.0 - p.x/pow(xy, 2.0))
				);
			
			e = dot(p,p);
			c = 1.0 - log(i)/log(100.0);
		}
	}
	
	gl_FragColor = vec4(c,c,c, 1.0);
}