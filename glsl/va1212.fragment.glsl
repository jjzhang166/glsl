// by @301z

#ifdef GL_ES
precision highp float;
#endif

const vec3 a = vec3(-0.36, 0.09, 0.0855);
const vec3 b = vec3(a.xy, 0.083);
const vec3 c = vec3(a.xy, 0.049);
const vec3 d = vec3(vec2(0.025, 0.035), 0.03);
const vec3 x = vec3(-0.063, -0.17, 0.065);
const vec3 y = vec3(-0.063, -0.16, 0.065);
const vec3 z = vec3(-1.0, 1.0, 1.0);

uniform vec2 resolution;

bool f(vec3 v) {
    return distance(gl_FragCoord.xy / resolution.y - 0.5 * vec2(resolution.x / resolution.y, 1.0), v.xy) < v.z;
}

void main() {
    gl_FragColor = vec4((f(vec3(a.xy + d.xy, d.z)) && f(vec3(a.xy * z.xy + d.xy, d.z)))
        ? vec3(1.0, 1.0, 1.0)
        : ((f(a) || f(a * z))
            ? (((f(b) && !f(c)) || (f(b * z) && !f(c * z)))
                ? vec3(0.6, 0.3, 0.5)
                : vec3(0.3, 0.1, 0.2))
            : (((f(x) && !f(y)) || (f(x * z) && !f(y * z)))
                ? vec3(0.0, 0.0, 0.0)
                : vec3(0.7 + sin(3.14159 * gl_FragCoord.y / resolution.y)))), 1.0);
}
