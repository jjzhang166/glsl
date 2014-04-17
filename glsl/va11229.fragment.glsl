#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

/////
#define PI      3.141592653589793
#define PI2     6.283185307179586
#define PI05    1.5707963267948966

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
float hash(float n) {
    return fract(sin(n)*43758.5453);
}

vec3 hash3( float n )
{
    return fract(sin(vec3(n,n+1.0,n+2.0))*vec3(43758.5453123,22578.1459123,19642.3490423));
}

vec3 noise3(vec3 x) {
    vec3 p = floor(x);
    vec3 f = fract(x);

    f = f*f*(3.0-2.0*f);
    float n = p.x + p.y*57.0 + 113.0*p.z;
    return mix(mix(mix( hash3(n+  0.0), hash3(n+  1.0),f.x),
                   mix( hash3(n+ 57.0), hash3(n+ 58.0),f.x),f.y),
               mix(mix( hash3(n+113.0), hash3(n+114.0),f.x),
                   mix( hash3(n+170.0), hash3(n+171.0),f.x),f.y),f.z);
}

vec3 noise3(vec2 x) {
    vec2 p = floor(x);
    vec2 f = fract(x);

    f = f*f*(3.0-2.0*f);
    float n = p.x + p.y*57.0;
    return mix(mix( hash3(n+  0.0), hash3(n+  1.0),f.x),
               mix( hash3(n+ 57.0), hash3(n+ 58.0),f.x), f.y);
}

vec3 bnoise3(vec3 x) {
    vec3 p = floor(x);
    float n = p.x + p.y*57.0 + 113.0*p.z;
    return hash3(n);
}

vec3 fbm33(vec3 p) {
    vec3 f = vec3(0.0);

    f += 0.5000 * noise3(p); p = p * 2.02;
    f += 0.2500 * noise3(p); p = p * 2.03;
    f += 0.1250 * noise3(p);

    return f / 0.9375;
}

vec3 fbm33(vec2 p) {
    const mat2 m = mat2(0.80, -0.60, 0.60, 0.80);
    vec3 f = vec3(0.0);

    f += 0.5000 * noise3(p); p = m * p * 2.02;
    f += 0.2500 * noise3(p); p = m * p * 2.03;
    f += 0.1250 * noise3(p);

    return f / 0.9375;
}

/////
vec3 voronoi(vec2 p, float amp) {
    const float OFSET = 0.8;
    vec2 ip = floor(p);
    
    vec3 ret;
    
    vec2 ncp;
    vec2 nop;
    //vec2 nip;
    float d;
    
    d = 1e10;
    for(int iy = -1; iy <= 1; iy++) {
        float fy = float(iy);
        for(int ix = -1; ix <= 1; ix++) {
            vec2 op = vec2(float(ix), fy);
            vec2 cip = ip + op;
            vec2 cp = (hash3(cip.x + hash(cip.y)).xy - 0.5) * OFSET * amp + cip;
            vec2 vpp = cp - p;
            float tmpd = dot(vpp, vpp);
            if(tmpd < d) {
                d = tmpd;
                nop = op;
                //nip = cip;
                ncp = cp;
            }
        }
    }
    ret.x = sqrt(d);
    //ret.y = hash(nip.x + hash(nip.y));
    
    d = 1e10;
    for(int iy = -1; iy <= 1; iy++) {
        float fy = float(iy);
        for(int ix = -1; ix <= 1; ix++) {
            vec2 cip = ip + vec2(float(ix), fy) + nop;
            vec2 cp = (hash3(cip.x + hash(cip.y)).xy - 0.5) * OFSET * amp + cip;
            
            d = min(d, dot((ncp + cp) * -0.5 + p, normalize(ncp - cp)));
        }
    }
    ret.z = d;
    
    return ret;
}

vec3 chocochips(vec2 p, float seed, float amp) {
    const int N = 8;
    const float DTHETA = PI2 / float(N);
    
    vec3 ret = vec3(0.0);
    
    float d = 1e10;
    
    //int cpi;
    vec2 ncp;
    vec2 cps[N];
    
    // find nearest
    for(int i = 0; i < N; i++) {
        float fi = float(i);
        float theta = DTHETA * fi;
        vec2 pp = sin(vec2(theta, theta + PI05)) * 0.35;
        vec3 h = hash3(fi + seed) - 0.5;
        pp += h.xy * amp;
        
        vec2 vpp = pp - p;
        float tmpd = dot(vpp, vpp);
        if(tmpd < d) {
            d = tmpd;
            ncp = pp;
            //cpi = i;
        }
        cps[i] = pp;
    }
    ret.r = sqrt(d);
    //ret.g = float(cpi + 1) / float(N);
    
    // border
    float bd = 1e10;
    for(int i = 0; i < N; i++) {
        vec2 mp = 0.5 * (ncp + cps[i]);
        vec2 bn = normalize(ncp - cps[i]);
        bd = min(bd, dot(p - mp, bn));
    }
    ret.b = bd;
    
    return ret;
}

/////
float displace(vec3 p3, vec3 seed, out vec3 dspout) {
    float d = 0.0;
    
    vec2 chocop = p3.xz;
    vec2 rndp = chocop + seed.xy;
    vec3 chnz = fbm33(rndp * 1.5) * 2.0 - 1.0;
    vec3 choco = chocochips(chocop + chnz.xy * 0.4, dot(seed, vec3(0.8)), 0.8);
    choco.z = min(max(0.0, 1.0 - length(chocop + chnz.yz * 0.3)) * 0.6, choco.z);
    
    const float CHOCO_Z_BIAS = 5.0;
    const float CHOCO_Z_ADD = 1.0;
    
    float chipd = max(0.0, choco.z * CHOCO_Z_BIAS - CHOCO_Z_ADD);
    float chiprimd = chipd - max(0.0, choco.z * CHOCO_Z_BIAS - (CHOCO_Z_ADD - 0.1));
    d += chipd + chiprimd;
    
    float chococrkd = pow(choco.x * 1.5, 2.0);
    vec3 crknz = fbm33(rndp * 8.0) * 2.0 - 1.0;
    vec3 mrcrack = voronoi((chocop + crknz.xy * 0.15) * 3.0, 0.9);
    float mrcrkd = pow(mrcrack.x, 4.0) * pow(1.0 - mrcrack.z, 4.0);
    float crackd = max(chococrkd, mrcrkd);
    d -= (chipd > 0.0)? 0.0 : (crackd * 0.3); // chocochip mask
    
    // fade
    float smf = smoothstep(1.0, 0.0, length(p3.xz));
    
    dspout.x = chipd;
    dspout.y = smf;
    
    return d * smf;
}

float cookie(vec3 p3, vec3 seed, out vec4 shdp) {
    // disc shape
    // on xz plane
    vec2 p = vec2(length(p3.xz), p3.y);
    
    const float R = 1.0;
    float d;
    float thick = 0.12 + cos(min(1.0, abs(p.x) / R) * PI05) * 0.05;
    
    const float BEND = -0.27;
    vec2 cs = sin(vec2(p.x * BEND + PI05, p.x * BEND));
    mat2 m = mat2(cs.x, -cs.y, cs.y, cs.x);
    p = m * p;
    
    vec2 ap = abs(p);
    d = length(vec2(max(0.0, ap.x - R), ap.y)) - thick;
    
    if(d < 0.2) { // displacement
        // simple noise
        float dsp = -fbm33((p3 + seed) * 4.0).x * 0.04;
        // chocochips and cracks
        vec3 dspout;
        dsp += (p.y < 0.0)? 0.0 : displace(p3, seed, dspout) * 0.2;
        
        d -= dsp;
        
        shdp.x = p.x; // cookie space x
        shdp.y = p.y; // cookie space y
        shdp.z = dsp; // displace
        shdp.w = dspout.x; // chocochip displace
    }
    
    return d;
}

float scene(vec3 wp, out vec4 shdp) {
    vec3 ip = floor(wp);
    
    const float SCALE = 4.0;
    vec3 p = (fract(wp) * 2.0 - 1.0) * 0.5 * SCALE;
    
    vec3 h3 = vec3(hash(ip.x + 0.123456), hash(ip.y + 0.789012), hash(ip.z + 0.567891));
    
    p = rotX(p, (h3.x + time * 0.1) * PI);
    p = rotY(p, (h3.y + time * 0.2) * PI);
    p = rotZ(p, (h3.z + time * 0.3) * PI);
    
    float d = 1e10;
    
    d = cookie(p, h3, shdp);
    
    return d / SCALE;
}

vec3 scene_normal(vec3 p) {
    const vec3 EPS = vec3(0.0001, 0.0, 0.0);
    vec3 n;
    vec4 dmy;
    n.x = scene(p + EPS.xyz, dmy) - scene(p - EPS.xyz, dmy);
    n.y = scene(p + EPS.zxy, dmy) - scene(p - EPS.zxy, dmy);
    n.z = scene(p + EPS.yzx, dmy) - scene(p - EPS.yzx, dmy);
    return normalize(n);
}

vec3 background(vec3 dir) {
    vec3 ret;
    float t;
    
    t = pow(abs(dir.y), 0.5);
    vec3 sky = vec3(0.95, 0.6, 0.3) + vec3(0.15, 0.2, 0.2) * -t;
    
    t = max(0.0, dir.z);
    t = pow(t, 50.0);
    vec3 sun = vec3(1.0, 0.8, 0.6) * max(0.0, t);
    
    ret = sky + sun;
    
    return ret;
}

vec3 cookie_shader(vec3 eye, vec3 n, vec4 shdp) {
    const vec3 litvec = vec3(0.577);
    
    vec3 dcol;
    vec3 scol;
    float dfs = dot(n, litvec);
    float spec = 0.0;
    if(dfs > 0.0) {
        vec3 hlfv = normalize((litvec + eye) * 0.5);
        spec = max(0.0, dot(hlfv, n));
    }
    
    if(shdp.w > 0.0 && shdp.y > 0.0) {
        // choco chips
        dcol = vec3(0.03, 0.0, 0.0);
        scol = vec3(1.0, 0.9, 0.8) * pow(spec, 180.0) * 0.5;
    } else {
        // cookie
        const vec3 basecol = vec3(0.6, 0.4, 0.02);
        const vec3 burncol = vec3(0.4, 0.13, 0.001);
        // center to around
        float t = pow(shdp.x, 4.0);
        if(shdp.y < 0.0) {
            t = max(t, shdp.x);
        }
        dcol = mix(basecol, burncol, clamp(t, 0.0, 1.0));
        scol = vec3(1.0) * pow(spec, 24.0) * 0.05;
    }
    
    float ao;
    ao = pow(clamp(1.0 + shdp.z * 20.0, 0.0, 1.0), 0.25);
    
    //dfs = max(0.0, dfs) * 0.8;
    dfs = pow(dfs * 0.5 + 0.5, 2.0) * 0.8; // half lambert
    
    vec3 amb = vec3(0.03);
    
    return dcol * dfs * ao + scol + amb;
}

void main(void) {
    vec3 rgb = vec3(0.0);
    
    vec2 screen = (gl_FragCoord.xy * 2.0 - resolution) / resolution.yy;
    
    // raymarch
    vec3 campos = vec3(0.0, time * 0.3, -4.5 + time * 0.8);
    vec3 pos = campos;
    
    //vec3 dir = normalize(vec3(screen, 2.0));
    vec2 sn = sin(screen * PI05 * 0.64);
    vec2 cs = cos(screen * PI05 * 0.64);
    vec3 dir = vec3(sn.x * cs.y, sn.y, cs.x * cs.y);
    
    // transform
    vec2 mpos = mouse.xy * 2.0 - 1.0;
    vec2 mangle = vec2(mpos.y * PI * 0.49, mpos.x * -PI);
    
    dir = rotY(rotX(dir, mangle.x), mangle.y);
    //pos = rotY(rotX(pos, mangle.x), mangle.y);
    campos = pos;
    
    float dd = 0.0;
    vec4 shdp = vec4(0.0);
    const int MARCH_MAX = 32;
    float itef = 0.0;
    for(int i = 0; i < MARCH_MAX; i++) {
        float d = scene(pos, shdp);
        if(d < 0.001) {
            break;
        }
        pos += d * 0.8 * dir;
        itef += 1.0;
    }
    
    float travel = length(pos - campos);
    vec3 norm = scene_normal(pos);
    
    vec3 ckcol = cookie_shader(-dir, norm, shdp);
    float itet = clamp(pow(itef / float(MARCH_MAX), 18.0), 0.0, 1.0);
    ckcol += vec3(0.9, 0.9, 0.2) * itet;
    rgb = ckcol;
    
    vec3 bgcol = background(dir);
    float bgt = clamp(exp(-travel * 0.16), 0.0, 1.0);
    rgb = mix(bgcol, ckcol, bgt);
    
    // post fx
    rgb *= smoothstep(0.0, 0.8, 1.0 - length(screen * 0.4));
    
    gl_FragColor = vec4(pow(rgb, vec3(1.0 / 2.2)), 1.0);
}
