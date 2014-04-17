#ifdef GL_ES
precision mediump float;
#endif

varying vec2 surfacePosition;
uniform float time;
#define maxiter 22

void main( void )
{
	vec2 z = vec2(0.0, 0.0);
	float p = 0.0;
	float dist = 1e20;
	for (int i=0; i<maxiter; ++i)
	{
		z = vec2(z.x*z.x-z.y*z.y, z.x*z.y*time) + surfacePosition;
		p = sqrt(z.x*z.x + z.y*z.y);
		if (p < dist)
		{
			dist = p;
		}
	}
	dist = abs(dist*4.0-1.2);
	gl_FragColor = vec4(dist*dist/1.0, dist*dist*dist/1.9, dist/0.7, 1.0);
}