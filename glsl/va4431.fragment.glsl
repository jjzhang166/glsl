// Iterative fractal generator
// made by darkstalker (@wolfiestyle)
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

// base pattern that generates the fractal
const mat3 gen = mat3(
	1, 1, 1,
	1, 0, 1,
	1, 1, 1
);

// max recursion
const int max_it = 4;

// GLSL doesn't allow to index a matrix with a variable, so we have to iterate it
bool inside(vec2 p)
{
	bool val;
	for (int y = 0; y < 3; ++y)
		for (int x = 0; x < 3; ++x)
		{
			if (x == int(p.x) && y == int(p.y))
			{
				val = bool(gen[y][x]);
				break;
			}
		}
	return val;
}

float ins(vec2 p)
{
	float val=0.0;
	for (int y = 0; y < 3; ++y)
		for (int x = 0; x < 3; ++x)
		{
			if (x == int(p.x) && y == int(p.y))
			{
				val = (gen[y][x]);
				break;
			}
		}
	return val;
}



void main( void ) {

	vec2 unipos = gl_FragCoord.xy / resolution.y;


	int val = 0;
	float n = 1.;
float r=0.0;
	for (int i = 0; i < max_it; ++i)
	{
		r = ins(mod(unipos * n, 2.));
		if (inside(mod(unipos * n, 2.)))
			val += 1;
		n *= 3.0;
	}

	float sa = float(val == max_it);
	vec3 clr = vec3(sa*0.4, sa*0.6, sa+r );
	

	gl_FragColor = vec4( clr, 1.0 );

}