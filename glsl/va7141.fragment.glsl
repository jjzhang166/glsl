#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

void main( void ) {

    vec2 position = (gl_FragCoord.xy / resolution.xy) - 0.5;

    const float T = 16.0;
    float t = mod(time, T);
    t = smoothstep(0.0, T/2.0, t) - smoothstep(T/2.0, T, t);
    t = 0.5 * sin(600.0 * position.y * t) + 0.5;

    gl_FragColor = vec4(vec3(t), 1.0);

}