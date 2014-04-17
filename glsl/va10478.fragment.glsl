#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
        vec2 center = .5*resolution.xy;
        float radius = .3*resolution.y;

        const float num_sides = 5.;
        const float delta_angle = 2.*3.14159/num_sides;

        float angle = 0. + .02 * sin(time) - .9 * sin(5.5* time) - .3 * cos(time/5.);
        int out_count = 0;

        for (float i = 0.; i < num_sides; i++) {
                vec2 a = center + radius*vec2(sin(angle), cos(angle));
                vec2 b = center + radius*vec2(sin(angle + 2.*delta_angle), cos(angle + 2.*delta_angle));

                vec2 p = gl_FragCoord.xy - a;
                vec2 o = vec2(-(b.y - a.y), b.x - a.x);

                if (dot(p, o) > 0.) {
                        if (++out_count == 2) {
                                discard;
                                return;
                        }
                }

                angle += delta_angle;
        }

        gl_FragColor = vec4(1., 1., 1., 1.);
}