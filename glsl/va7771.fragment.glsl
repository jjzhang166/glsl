// Playing around with Lissajous curves.
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

const float MAX_ITER = 400.0;
const float DOTS_PER_SEC = 20.0;

void main( void ) {
    float sum = 0.0;
    float size = resolution.x / 800.0;
    for (float i = 0.0; i < MAX_ITER; ++i) {
        vec2 position = resolution / 2.0;
	float t = (i + time) / 5.0;
	float c = i * 4.0;
        position.x += sin(8.0 * t + c) * resolution.x * 0.4 * mod(time, MAX_ITER / DOTS_PER_SEC) * DOTS_PER_SEC / MAX_ITER;
        position.y += sin(t) * resolution.y * 0.48;

        sum += size / length(gl_FragCoord.xy - position);
        if (i > (DOTS_PER_SEC * mod(time, MAX_ITER / DOTS_PER_SEC))) {
            break;
        }
    }
    gl_FragColor = vec4(0, sum * 0.5, sum, 1);
}