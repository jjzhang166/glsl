#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
varying vec2 surfacePosition;

#define maxiter 32

void main( void )
{
	vec2 s = surfacePosition*2.0;
	vec2 z = s;
	float p = 0.0;
	float dist = 1e20;
	for (int i=0; i<maxiter; ++i)
	{
		z = s + vec2(
			dot(z, vec2(z.x, -z.y)),
			z.x * z.y * 2.0
		);
		p = length(
			vec2(
				z.x + cos(z.y+time*0.99), 
			     	z.x + sin(z.y+time*1.01)
			)
		);
		if (p < dist)
		{
			dist = p;
		}
	}
	dist = abs(cos(dist)*2.0-1.0);
	gl_FragColor = vec4(dist*dist, dist*dist*dist/1.9, dist/0.7, 1.0);
}