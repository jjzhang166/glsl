#ifdef GL_ES
precision mediump float;
#endif

varying vec2 surfacePosition;
uniform float time;
void main(void)
{
	vec2 p = vec2(tan(time)*cos(time),cos(time)*sin(time));
	vec2 z = surfacePosition;
	float e;
	float c = 0.0;
	for(float i = .0; i < 256.; i++)
	{
		if(e < 4.0)
		{
			z = p + vec2(z.x*z.x - z.y*z.y, 2.0*z.x*z.y);
			e = dot(z,z);
			c += (10. -i);
		}
	}
	c /= 50.;
    gl_FragColor = vec4(c,c,c, 1.0 );
}