#ifdef GL_ES
precision mediump float;
#endif

varying vec2 surfacePosition;

#define maxiter 50

void main( void )
{
	vec2 z = vec2(0.0, 0.0);
	float p = 0.0;
	float dist = 1e20;
	for (int i=0; i<maxiter; ++i)
	{
		z = vec2(z.x*z.x-z.y*z.y, z.x*z.y*2.0) + surfacePosition;
		p = sqrt(0.25*z.x*z.y);
		if (p < dist)
		{
			dist = p;
		}
	}
	dist = dist*8.0;
	gl_FragColor = vec4(dist*dist/1.1, dist/0.8, dist*dist*dist/0.9, 1.0);
}