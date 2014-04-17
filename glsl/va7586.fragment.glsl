#ifdef GL_ES
precision mediump float;
#endif
// zoom out all the way
// on st patty's day
//miles
varying vec2 surfacePosition;
void main(void)
{
	vec2 p = vec2(-.12,.756);
	vec2 z = surfacePosition;
	float e;
	float c = 0.0;
	for(float i = .0; i < 256.; i++)
	{
		if(e < 2.0)
		{
			z = cos(p) + vec2(z.x*z.x - z.y*z.y, 2.0*z.x*z.y);
			e = dot(tan(z), cos(p));
			c += (2000. *tan(i));
		}
	}
	c /= 20.;
    gl_FragColor = vec4(tan(c),cos(c),sin(c), 1.0 );
}