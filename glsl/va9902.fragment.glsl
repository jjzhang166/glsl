/*
inspired by http://pyramid-inc.net/
But I'm not a staff :)
*/

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
const float PI = 3.14159;

vec3 rotX(vec3 p,float a){
    float s = sin(a);
    float c = cos(a); 
    return vec3(p.x, p.y * c - s * p.z, p.y * s + c * p.z);
}

vec3 rotY(vec3 p,float a){
    float s = sin(a);
    float c = cos(a); 
    return vec3( p.z * s + p.x * c, p.y, p.z * c - p.x * s);
}

vec3 rotZ(vec3 p,float a){
    float s = sin(a);
    float c = cos(a); 
    return vec3(p.x * c - s * p.y, p.x * s + c * p.y, p.z);
}

/////
float sphere(vec3 p, float r) {
    return length(p) - r;
}

float plane(vec3 p, vec4 n) {
    return dot(p, n.xyz) - n.w;
}

/////
float pyramid(vec3 p) {
    p = abs(p);
    return plane(p, vec4(0.57, 0.57, 0.57, 0.5));
}

float ring(vec3 p, vec3 xyr) {
    vec3 ap = abs(p);
    vec2 pp = vec2((ap.x + ap.z) * 0.707, p.y) - xyr.xy;
    return length(pp) - xyr.z;
}

float scene(vec3 p) {
    float d = 1e10;
    
    p.xz = fract(p.xz * 0.5 + 0.5) * 2.0 - 1.0;
    
    d = plane(p, vec4(0.0, 1.0, 0.0, 0.0));
    d = min(d, pyramid(p));
    d = min(d, ring(rotY(p, time), vec3(0.55, 0.45, 0.03)));
    
    return d;
}

vec3 sceneNormal(vec3 p) {
    const vec3 EPS = vec3(0.0001, 0.0, 0.0);
    vec3 n;
    n.x = scene(p + EPS.xyz) - scene(p - EPS.xyz);
    n.y = scene(p + EPS.zxy) - scene(p - EPS.zxy);
    n.z = scene(p + EPS.yzx) - scene(p - EPS.yzx);
    return normalize(n);
}

float ambientOcculusion(vec3 p, vec3 n, float pwr) {
    const float STEP = 0.05;
    float ao = 0.0;
    float d;
    for(int i = 1; i <= 3; i++) {
        float t = float(i);
        d = STEP * t;
        ao += (d - scene(p + n * d)) / (t * t);
    }
    return max(0.0, 1.0 - ao * pwr);
}

float shadow(vec3 p, vec3 n, vec3 litdir) {
    // parallel light
    vec3 pos = p + n * 0.0001;
    float s = 1.0;
    for(int i = 0; i < 64; i++) {
        float d = scene(pos);
        if(d < 0.0001) {
            s = 0.0;
            break;
        }
        pos += litdir * d;
    }
    
    return s;
}

/////
void main(void) {
    vec2 scrn = (gl_FragCoord.xy * 2.0 - resolution.xy) / resolution.yy;
    vec3 rgb;
    
    rgb = vec3(abs(scrn), 0.0);
    
    vec3 eye = vec3(0.0, 0.0, 6.0);
    vec3 dir = normalize(vec3(scrn, -4.0));
    
    vec2 mpos = mouse.xy * 2.0 - 1.0;
    vec2 mangle = vec2(-(0.55 - mpos.y * 0.45) * PI * 0.5, mpos.x * -PI);
    
    dir = rotY(rotX(dir, mangle.x), mangle.y);
    eye = rotY(rotX(eye, mangle.x), mangle.y);
    
    vec3 p = eye;
    for(int i = 0; i < 64; i++) {
        float d = scene(p);
        if(d < 0.001) {
            break;
        }
        p += d * dir;
    }
    
    float LIT_R = 2.0 + sin(time / 3.0 * PI) * 0.5;
    float litangle = time / 19.0 * PI;
    vec3 litdir = normalize(vec3(sin(litangle) * LIT_R, 1.0, cos(litangle) * LIT_R));
    
    vec3 n = sceneNormal(p);
    float dfs = max(0.0, dot(n, litdir));
    float ao = ambientOcculusion(p, n, 3.0);
    float shdw = shadow(p, n, litdir);
    
    vec3 objcol = mix(vec3(0.71, 0.0, 0.0) * ao, vec3(0.9, 0.45, 0.0), dfs * shdw);
    rgb = objcol;
    
    float dist = length(p - eye) - 6.0;
    float fade = exp(-dist * 0.1);
    
    rgb = mix(vec3(1.0, 0.9, 0.7), objcol, clamp(0.0, 1.0, fade));
    
    gl_FragColor = vec4(rgb, 1.0);
}
