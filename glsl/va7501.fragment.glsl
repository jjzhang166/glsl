#ifdef GL_ES
precision mediump float;
#endif

varying vec2 surfacePosition;
void main(void)
{
	vec2 p = surfacePosition, a1 = vec2(1,0), a2 = vec2(-.5,-sqrt(3.)/2.), a3 = vec2(-.5,sqrt(3.)/2.);
	float e,c;
	for(float i = .0; i < 512.; i++)
	{
		e = min(distance(p,a1),min(distance(p,a2),distance(p,a3)));
		if(e > 0.000001)
		{
			p = vec2(2.*p.x/3.+(p.x*p.x-p.y*p.y)/3./pow(p.x*p.x+p.y*p.y,2.), 2.*p.y/3.*(1.-p.x/pow(p.x*p.x+p.y*p.y,2.)));	
			c = log(i)/log(256.);
		}
		
	}
    gl_FragColor = vec4(c,c,c, 1.0 );
}