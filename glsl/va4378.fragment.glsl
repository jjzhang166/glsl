// Iterative fractal generator
// made by darkstalker (@wolfiestyle)
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// base pattern that generates the fractal
const mat4 gen = mat4(
	1, 1, 0, 1,
	1, 0, 1, 1,
	1, 1, 0, 1,
	1, 0, 1, 1
);

// max recursion
const int max_it = 3;

// GLSL doesn't allow to index a matrix with a variable, so we have to iterate it
bool inside(vec2 p)
{
	bool val;
	for (int y = 0; y < 4; ++y)
		for (int x = 0; x < 4; ++x)
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

	if (position.x > 4. || position.y > 4.)
		discard;

	int val = 0;
	float n = 1.;

	for (int i = 0; i < max_it; ++i)
	{
		if (inside(mod(position * n, 4.)))
			val += 1;
		n *= 4.;
	}

	float color = float(val == max_it);

	gl_FragColor = vec4( vec3( color ), 1.0 );

}