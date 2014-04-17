#ifdef GL_ES
precision highp float;
#endif

//varying vec2 position;
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) 
{
	vec2 position = gl_FragCoord.xy / resolution.xy;
	vec2 z = vec2(0.0);
	const int MAXITER = 255;
	
	int itern;
	for (int iter = 0; iter <= MAXITER; iter++ )
	{
		//c is the position
		float tz0 = z[0];
		z[0] = z[0] * z[0] - z[1] * z[1] + 4.*(position.x-.5);
		z[1] = 2. * tz0 * z[1] + 4.*(position.y-.5);
		itern = iter;
		if (dot(z,z) > 4.)
		{
			break;
		}
	}
	gl_FragColor = vec4( pow(1.-float(itern)/float(MAXITER),5.0), 0.0, 0.0, 1.0);
}