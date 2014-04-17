precision mediump float;

uniform float time;

void main() {
    float t = time * 30.0;
    gl_FragColor = vec4(vec3(mod(t - fract(t), 2.0)), 1.0);
}