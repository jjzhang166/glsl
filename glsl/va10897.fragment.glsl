#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
varying vec2 surfacePosition;

#define maxiter 100

void main( void )
{
	vec2 s = surfacePosition*2.0;
	vec2 z = s;//vec2(cos(time/31.0), sin(time/32.0));
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
				z.x - cos(z.y+time*0.43517), 
			     	z.y + sin(z.x-time*0.41235)
			)
		);
		if (p < dist)
		{
			dist = p;
		}
	}
	dist = abs(dist);
	gl_FragColor = vec4(dist/abs(cos(dist*4.0)*2.0-1.0), sin(dist/2.0)*dist*dist/0.5, dist/2.7, 1.0);
}