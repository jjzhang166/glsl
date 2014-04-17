#ifdef GL_ES
precision highp float;
#endif

// Modutropolis by @acaudwell
// thealphablenders.com

uniform vec2 resolution;
uniform vec2 mouse;
uniform float time;

#define MAX_RAY_STEPS 250

float aspect_ratio = resolution.y / resolution.x;
float ray_scale    = (1.0 / max(resolution.x, resolution.y)) * 0.5;
float fov          = tan ( 75.0 * 0.017453292 * 0.5 );

float building(vec3 p) {

    float box = 3.0;

    vec3 q = mod(p, box)-box*0.5;

    vec3 b = vec3(box*0.5, 1.5, 1.5);
    float r = fract(p.y)*0.1;

    float bounds = length(max(abs(p)-vec3(box*2.0, box*4.0, box), 0.0));
    float scafold= max( length(max(abs(q)-b, 0.0)), length(max(abs(q)-b, -r))-r);

    return max(bounds , scafold);
}

float city(vec3 p) {

    float box = 20.0;

    float hv = -mod(ceil(p.x/20.0), 3.0)*2.0;

    float horizon = 400.0;

    vec3 bb = vec3(horizon , 47.05 + hv, horizon );

    vec3 q = mod(p, box)-box*0.5;

    float b = building(p);

    float bounds    =  length(max(abs(p)-bb, 0.0));
    float buildings =  building(q);

    return max( bounds, buildings );
}

void main( void ) {

    vec2 tx = ((gl_FragCoord.xy / resolution)-0.5) * 2.0;

    float a  = time*0.09;//(mouse.x-0.5)*3.142;
    float sa = sin(a)*1.1;
    float ca = cos(a);

    vec3 dir = vec3( tx.x * fov , tx.y * fov * aspect_ratio, 1.0 );
 
    //dir.xy   = vec2( dir.x * ca - dir.y * sa, dir.x * sa + dir.y * ca);
    dir.xz   = vec2( dir.x * ca - dir.z * sa, dir.x * sa + dir.z * ca);

    dir = normalize(dir);

    vec3 cam = vec3(0.0, 45.0, 0.0);
    //cam.xz   = vec2( cam.x * ca - cam.z * sa, cam.x * sa + cam.z * ca);

    vec3 ray = cam;

    float l  = 0.0;
    float d  = 0.0;
    float e  = 0.00001;
    float it = 0.0;

    for(int i=0;i<MAX_RAY_STEPS;i++) {
        d = city(ray);

        ray += d * dir;
        l += d;

        if(d<e) break;

        e  = ray_scale * l;
        it++;
    }

    float f = 0.9-(it/float(MAX_RAY_STEPS));

    vec3 bg = vec3(pow(length(tx*0.5),3.5));

    float lights = max(0.0, pow(max(abs(tx.y), 1.0), 1.0))*0.5;
    float sky    = max(0.0, pow(max(tx.y+min(300.0,l)*0.01, 0.0), 0.9))*0.9;

    vec3 lc = vec3(lights*1.1, 1.2*lights, lights*1.5)*0.67;
    vec3 sc = vec3(sky*0.1, sky*0.20, sky);

    vec3 c = vec3(1.0-f)*max(lc,sc);

    gl_FragColor = vec4(c, 1.0);
}