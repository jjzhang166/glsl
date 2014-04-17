// by @eddbiddulph

#ifdef GL_ES
precision mediump float;
#endif

uniform float   time;
uniform vec2    mouse;
uniform vec2    resolution;

float box(float e0, float e1, float x)
{
    return step(e0, x) - step(e1, x);
}

float lightMask(vec2 tc)
{
    tc += 0.5; // put centre at {0.0, 0.0}
    return box(0.0, 1.0, tc.x) * box(0.0, 1.0, tc.y);
}

vec3 lightTexture(vec2 tc)
{
    tc += 0.5; // put centre at {0.0, 0.0}
    tc *= 8.2 / 8.0; // add a black border to all edges
    tc = mod(tc * 8.0, 1.0);
    return vec3(step(0.2, tc.x) * step(0.2, tc.y)) * vec3(1.2, 1.15, 0.9);
}

// p must be in lightsource space
float lightVolume(float dist, vec3 p)
{
    return step(dist - 0.001, p.z);
}

// p must be in lightsource space
vec2 projectToLight(float dist, vec3 p)
{
    return p.xy * dist / p.z;
}

// combined illumination value
// p must be in lightsource space
vec3 light(vec3 p)
{
    vec2 proj = projectToLight(0.5, p);
    return lightTexture(proj) * lightMask(proj) * lightVolume(0.5, p) / pow(p.z, 2.0);
}

float plane(vec3 norm, float dist, vec3 ro, vec3 rd)
{
    return (dist - dot(ro, norm)) / dot(rd, norm);
}

vec3 rotate(vec3 vec, vec3 axis, float angle)
{
    vec3 prl = axis * dot(axis, vec), ppd = vec - prl;
    return prl + ppd * cos(angle) + cross(ppd, axis) * sin(angle);
}


void main(void)
{
    vec3 ro = vec3(1.0, 1.0, 0.0), rd;
    
    rd.xy = (gl_FragCoord.xy / resolution.xy * 2.0 - 1.0) * vec2(resolution.x / resolution.y, 1.0);
    rd.z = 1.0;

    rd = rotate(rd, vec3(1.0, 0.0, 0.0), -0.4);
    
    ro.z -= 3.0;
    
    // ray start point and vector, in lightsource space
    vec3 ro_l = rotate(ro, vec3(0.0, 1.0, 0.0), time), rd_l = rotate(rd, vec3(0.0, 1.0, 0.0), time);
    
    ro_l = rotate(ro_l, vec3(1.0, 0.0, 0.0), time * 0.3);
    rd_l = rotate(rd_l, vec3(1.0, 0.0, 0.0), time * 0.3);
    
    // wall
    float t0 = plane(vec3(0.0, 0.0, 1.0), 1.0, ro, rd);
    
    // floor
    float t1 = plane(vec3(0.0, -1.0, 0.0), 1.0, ro, rd);
    
    // lightsource
    float t2 = plane(vec3(0.0, 0.0, 1.0), 0.5, ro_l, rd_l);
    
    // intersection with wall and floor
    float t = mix(t0, min(t0, t1), step(0.0, t1));
    
    float lmask = 1.0;
    vec3 hit_p = ro + rd * t;
    
    // set colour for wall
    vec3 col = vec3(abs(cos(hit_p.x) * sin(hit_p.y) * cos(hit_p.z))) * vec3(0.1, 0.05, 0.05);
    
    // set colour for floor
    if(hit_p.y < -0.999)
        col = vec3(abs(cos(hit_p.x) * sin(hit_p.y) * cos(hit_p.z))) * vec3(0.05, 0.1, 0.05);
    
    // intersection with lightsource
    if(t2 > 0.0 && t > t2)
    {
        vec2 hit_l = ro_l.xy + rd_l.xy * t2;
        if(lightMask(hit_l.xy) > 0.0)
        {
            lmask = step(0.0, -rd_l.z);
            col = vec3(0.0); // do not add extra texture to the lightsource
            t = t2;
        }
    }
    
    vec3 hit_l = ro_l + rd_l * t;
    hit_p = ro + rd * t;
    
    vec3 fog = vec3(0.0);
    for(int i = 0; i < 80; ++i)
    {
        vec3 v = mix(ro_l, hit_l, float(i) / 79.0);
        fog += light(mix(ro_l, hit_l, float(i) / 79.0));
    }

    vec3 lcol = light(hit_l);
    
    gl_FragColor.a = 1.0;
	gl_FragColor.rgb = vec3(t / 10.0) + lcol * lmask + col + fog * 0.015;
}
