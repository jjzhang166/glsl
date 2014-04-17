#ifdef GL_ES
precision mediump float;
#endif

varying vec2 surfacePosition;

#define maxiter 20
#define rgb 3, 7, 12

void main( void )
{
	vec2 z = vec2(0.0, 0.0);
	vec3 col = vec3(0.0);
	for (int i=0; i<maxiter; ++i)
	{
		z = vec2(z.x*z.x-z.y*z.y, z.x*z.y*2.0) + surfacePosition;
	}
	float m = z.x*z.x + z.y*z.y;
	if (m < 8.0)
	{
		col = sin(m*vec3(rgb))/2.0+0.5;
	}
	gl_FragColor = vec4(col, 1.0);
}