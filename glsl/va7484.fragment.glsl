#ifdef GL_ES
precision mediump float;
#endif

varying vec2 surfacePosition;
void main(void)
{
	vec2 p = surfacePosition;
	vec2 z = vec2(0,0);
	float e;
	float c = 100.0;
	for(float i = .0; i < 256.; i++)
	{
		if(e < 4.0)
		{
			z = p + vec2(z.x*z.x - z.y*z.y, 2.0*z.x*z.y);
			e = dot(z,z);
			c += (20. -i);
		}
	}
	c /= 400.;
    gl_FragColor = vec4(c,c,c, 1.0 );
}