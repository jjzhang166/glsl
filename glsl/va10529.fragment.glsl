#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define CELL_SIZE 60.

float
in_star(const in vec2 pos, const in vec2 center, const float radius)
{
	const float num_sides = 5.;
        const float delta_angle = 2.*3.14159/num_sides;

        float angle = 0. + .02 * sin(time) - .9 * sin(5.5* time) - .3 * cos(time/5.);

	int out_count = 0;
	
	for (float i = 0.; i < num_sides; i++) {
                vec2 a = center + radius*vec2(sin(angle), cos(angle));
                vec2 b = center + radius*vec2(sin(angle + 2.*delta_angle), cos(angle + 2.*delta_angle));

                vec2 p = pos - a;
                vec2 q = vec2(-(b.y - a.y), b.x - a.x);

                if (dot(p, q) > 0.) {
                        if (++out_count == 2)
                                return 0.;
                }

                angle += delta_angle;
        }

	return 1.;
}

void main( void ) {
	vec2 center = .5*vec2(CELL_SIZE, CELL_SIZE);
	float radius = .45*CELL_SIZE;
	
	vec2 pos = mod(gl_FragCoord.xy, CELL_SIZE);

	float c = 0.;
	
#define SQRT_SAMPLES 3.
#define SAMPLES (SQRT_SAMPLES*SQRT_SAMPLES)
	
	for (float dx = 0.; dx < 1.; dx += 1./SQRT_SAMPLES)
		for (float dy = 0.; dy < 1.; dy += 1./SQRT_SAMPLES)
			c += in_star(pos + vec2(dx, dy), center, radius);
	
	c *= 1./SAMPLES;
	
        gl_FragColor = vec4(c, c, c, 1.);
}