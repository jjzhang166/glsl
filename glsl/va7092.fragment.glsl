#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main(void)
{
    float direction = 0.5; // -1.0 to zoom out
    ivec2 sectors;
    vec2 coordOrig = gl_FragCoord.xy / resolution.xy;
    coordOrig.y *= resolution.y / resolution.x;
    const int lim = 7;

    vec2 coordIter = coordOrig / exp(mod(direction*time, 1.1));
	
    for (int i=0; i < lim; i++) {
        sectors = ivec2(floor(coordIter.xy * 3.0));
        if (sectors.x == 1 && sectors.y == 1) {
            // make a hole
            gl_FragColor = vec4(0.0);

            return;
        } else {
            // map current sector to whole carpet
            coordIter.xy = coordIter.xy * 3.0 - vec2(sectors.xy);
        }
    }

    gl_FragColor = vec4(coordOrig.x, 0.5, coordOrig.y, 1.0) + 0.05*(1.1 - mod(direction*time, 1.1));
}