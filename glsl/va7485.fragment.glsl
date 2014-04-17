#ifdef GL_ES
precision mediump float;
#endif

varying vec2 surfacePosition;
void main(void)
{
	vec2 p = surfacePosition;
	float e;
	float c;
	for(float i = .0; i < 512.; i++)
	{
		if(e < 100.0)
		{
			p = vec2(2.*p.x/3.+(p.x*p.x-p.y*p.y)/3./pow(p.x*p.x+p.y*p.y,2.), 2.*p.y/3.*(1.-p.x/pow(p.x*p.x+p.y*p.y,2.)));
			e = dot(p,p);
			c = 1. - log(i)/log(512.);
		}
	}
    gl_FragColor = vec4(c,c,c, 1.0 );
}