// Ray Marching (Sphere Tracing) experiment by Riccardo Gerosa aka h3r3 
// Blog: http://www.postronic.org/h3/ G+: https://plus.google.com/u/0/117369239966730363327 Twitter: http://twitter.com/#!/h3r3
// This GLSL shader is based on the awesome work of JC Hart and I Quilez. Features two lights with soft shadows, blobby objects, object space ambient occlusion.

precision mediump float;

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
const float PI = 3.14159;
const int MAX_RAYMARCH_ITER = 50;
const float MIN_RAYMARCH_DELTA = 0.0015;
const float GRADIENT_DELTA = 0.002;
const float SOFT_SHADOWS_FACTOR = 3.0;

float sdSphere(vec3 p, float s) {
    return length(p) - s;
}

float sdTorus(vec3 p, vec2 t) {
    vec2 q = vec2(length(p.xz) - t.x, p.y);
    return length(q) - t.y;
}

float sdPlane(vec3 p, vec4 n) { // n must be normalized
    return dot(p, n.xyz) + n.w;
}

float blend(float d1, float d2) {
    float dd = cos((d1 - d2) * PI);
    return mix(d1, d2, dd);
}

float world(vec3 p, vec3 ray_dir) { //  ray_dir is used only for some optimizations
    float plane = sdPlane(p + vec3(0,0.3,0), vec4(normalize(vec3(0, 1, -0.5)),0));
    if (ray_dir.z <= 0.0 || p.z < 1.0) { // Optimization: try not to compute blobby object distance when possible
        float sphere1 = sdSphere(p + vec3(cos(time * 0.2 + PI) * 0.45,0,0), 0.25);
        float sphere2 = sdSphere(p + vec3(cos(time * 0.2) * 0.45,0,0), 0.25);
        float torus = sdTorus(vec3(p.y + sin(time) *0.1, p.z + cos(time) * 0.1, p.x), vec2(0.2, 0.08));
        return min(min(blend(sphere1, torus), blend(sphere2, torus)), plane);
    } else {
        return plane;
    }
}

float map(vec3 p) {
    return world(p, vec3(0,0,0));
}

vec3 gradientNormal(vec3 p) {
    return normalize(vec3(
        map(p + vec3(GRADIENT_DELTA, 0, 0)) - map(p - vec3(GRADIENT_DELTA, 0, 0)),
        map(p + vec3(0, GRADIENT_DELTA, 0)) - map(p - vec3(0, GRADIENT_DELTA, 0)),
        map(p + vec3(0, 0, GRADIENT_DELTA)) - map(p - vec3(0, 0, GRADIENT_DELTA))));
}

bool raymarch(vec3 ray_start, vec3 ray_dir, out float dist, out vec3 p, out int iterations) {
    dist = 0.0;
    float minStep = 0.0001;
    for (int i = 1; i <= MAX_RAYMARCH_ITER; i++) {
        p = ray_start + ray_dir * dist;
        float mapDist = world(p, ray_dir);
        if (mapDist < MIN_RAYMARCH_DELTA) {
           iterations = i;
           return true;
        }
        if(mapDist < minStep) { mapDist = minStep; }
        dist += mapDist;
        float ifloat = float(i);
        minStep += 0.0000018 * ifloat * ifloat;
    }
    return false;
}

bool raymarch_to_light(vec3 ro, vec3 rd, float maxDist, out float dist, out vec3 p, out int iterations, out float intensity) {
    dist = 0.0;
    float minStep = 0.0001;
    intensity = 1.0;
    for (int i = 1; i <= MAX_RAYMARCH_ITER; i++) {
        p = ro + rd * dist;
        float mapDist = world(p, rd);
        if (mapDist < MIN_RAYMARCH_DELTA) {
            iterations = i;
            return true;
        }
        intensity = min(intensity, SOFT_SHADOWS_FACTOR * mapDist / dist);
        if(mapDist < minStep) { mapDist = minStep; }
        dist += mapDist;
        if (dist >= maxDist) { break; }
        float ifloat = float(i);
        minStep += 0.0000018 * ifloat * ifloat;
    }
    return false;
}

float ambientOcclusion(vec3 p, vec3 n) {
    float step = 0.03;
    float ao = 0.0;
    float dist;
    for (int i = 1; i <= 3; i++) {
        dist = step * float(i);
        ao += (dist - map(p + n * dist)) / float(i * i);
    }
    return ao;
}

void main( void ) {
    vec2 position = vec2((gl_FragCoord.x - resolution.x / 2.0) / resolution.y, (gl_FragCoord.y - resolution.y / 2.0) / resolution.y);
    vec3 ro = vec3(0, 0, -2);
    vec3 rd = normalize(vec3(position,0) - ro);

    vec3 lp = vec3(-0.5 + sin(time), 1.0, -1.0 + cos(time * 0.5) * 2.0);

    vec4 color;
    float dist; vec3 p; int iterations;
    if (raymarch(ro, rd, dist, p, iterations)) {
        float d2; vec3 p2; int i2; float intensity;

        vec3 ldir = lp - p;
        float ldist = length(ldir);
        ldir = normalize(ldir);
        vec3 n = gradientNormal(p);
	    
        float ambient = (0.16 - ambientOcclusion(p, n)) / (dist * dist * 0.17);
        vec3 diffuse = vec3(0,0,0);
        if (!raymarch_to_light(p + ldir * 0.1, ldir, ldist, d2, p2, i2, intensity)) {
            diffuse = vec3(1.0, 0.8, 0.6) * max(0.0, dot(normalize(lp - p), n) * intensity * 3.0 / (dist * dist));
        }
        color = vec4(vec3(0.9,0.8,0.6) * max(diffuse, ambient), 1);
    } else {
        color = vec4(0,0,0,0);
    }
    gl_FragColor = color;
}