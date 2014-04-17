#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;
uniform vec2 mouse;

void main() {
    float x = gl_FragCoord.x / resolution.x, t = 10.;
    float s = (sin(x * t / mouse.x) * 0.25 + 0.5) * resolution.y;
    float c = (cos(x * t) * t / mouse.x) * 0.25 * resolution.y / resolution.x;
    gl_FragColor = vec4(vec3(abs(s - gl_FragCoord.y) / sqrt(1.0 + c * c) - 0.1), 1.0);
}
