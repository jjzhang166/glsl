#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main() {
    vec4 color;
    float y = gl_FragCoord.y;
    
    vec4 white = vec4(1);
    vec4 red = vec4(1, 0, 0, 1);
    vec4 blue = vec4(0, 0, 1, 1);
    vec4 green = vec4(0, 1, 0, 1);

    float step1 = 320.0 * 0.20;
    float step2 = 320.0 * 0.50;
    float step3 = 320.0 * 0.65;

    if (y < step1) {
        color = white;
    } else if (y < step2) {
        float x = smoothstep(step1, step2, y);
        color = mix(white, red, x);
    } else if (y < step3) {
        float x = smoothstep(step2, step3, y);
        color = mix(red, blue, x);
    } else {
        float x = smoothstep(step3, 320.0, y);
        color = mix(blue, green, x);
    }

    gl_FragColor = color;
}
