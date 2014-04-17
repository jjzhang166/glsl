#ifdef GL_ES
precision mediump float;
#endif

varying vec2 surfacePosition;

#define maxiter 100

void main( void )
{
	vec2 z = vec2(0.0, 0.0);
	float iter = 0.0;
	for (int i=0; i<maxiter; ++i)
	{
		z = vec2(z.x*z.x-z.y*z.y, z.x*z.y*2.0) + surfacePosition;
		if (z.x*z.x + z.y*z.y > 8.0)
		{
			iter = float(i);
			break;
		}
	}
	iter /= float(maxiter);
	gl_FragColor = vec4(vec3(iter), 1.0);
}