// Iterative fractal generator
// made by darkstalker (@wolfiestyle)
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
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

void main( void ) {

	vec2 position = gl_FragCoord.xy / resolution.y * 3.;

	if (position.x > 3. || position.y > 3.)
		discard;

	int val = 0;
	float n = 1.;

	for (int i = 0; i < max_it; ++i)
	{
		if (inside(mod(position * n, 3.)))
			val += 1;
		n *= 3.;
	}

	float color = float(val == max_it);

	gl_FragColor = vec4( vec3( color ), 1.0 );

}