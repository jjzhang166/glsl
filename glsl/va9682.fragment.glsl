// Windows Chrome (ANGLE) => White
// Windows Firefox (ANGLE) => White
// Windows Firefox (webgl.prefer-native-gl=true) => Black

precision mediump float;

uniform vec2 resolution;

void main() {
    vec3 runtimeZeroes = max(vec3(0.0), -resolution.xxx);
    gl_FragColor = vec4(pow(runtimeZeroes, runtimeZeroes), 1.0);
}