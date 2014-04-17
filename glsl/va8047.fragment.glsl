#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 c_mult(vec2 a, vec2 b)
{
	return vec2 (a.x * b.x - a.y * b.y,
		    (a.x + a.y)*(b.x + b.y) - a.x * b.x - a.y * b.y);	
}

float mandelbrot(vec2 position, const int maxIter)
{
	float x = position.x;
	float y = position.y;
	
	vec2 z = vec2(0.0, 0.0);
	int j = 0;
	for(int i = 0; i < 100; ++i)
	{
		z = c_mult(z, z) + position;
		if (abs(z.x) > 2.0 || abs(z.y) > 2.0)
		{
			break;	
		}
		j = i;
	}
	float color = float(j) / 100.0;
	//float color = sign(x) + 1.0 + sign(y) + 1.0;
	return color;	
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	vec2 mandelPosition = (position - 0.5) * 4.0; 
	
	vec2 center = vec2(0, 0);
	
	float scale = 1.0;
	
	mandelPosition = (mandelPosition + center) * scale;
	
	gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0) * mandelbrot(mandelPosition, 100);
	
	
	//gl_FragColor = vec;

}

