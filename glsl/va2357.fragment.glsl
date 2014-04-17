// inspired by Escher's "Depth", still needs some work!
// https://www.google.co.uk/search?q=escher+depth
// simon green 26/01/2011

#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform float time;

// CSG operations
float _union(float a, float b)
{
    return min(a, b);
}

float intersect(float a, float b)
{
    return max(a, b);
}

float difference(float a, float b)
{
    return max(a, -b);
}

// primitive functions
// these all return the distance to the surface from a given point

float plane(vec3 p, vec3 planeN, vec3 planePos)
{
    return dot(p - planePos, planeN);
}

float plane(vec3 p, vec3 n, float d)
{
    return dot(p, n) - d;
}

float box( vec3 p, vec3 b )
{
  vec3  di = abs(p) - b;
  float mc = max(di.x, max(di.y, di.z));
  return min(mc,length(max(di,0.0)));
}

float sphere(vec3 p, float r)
{
    return length(p) - r;
}

// transforms
vec3 rotateX(vec3 p, float a)
{
    float sa = sin(a);
    float ca = cos(a);
    vec3 r;
    r.x = p.x;
    r.y = ca*p.y - sa*p.z;
    r.z = sa*p.y + ca*p.z;
    return r;
}

vec3 rotateY(vec3 p, float a)
{
    float sa = sin(a);
    float ca = cos(a);
    vec3 r;
    r.x = ca*p.x + sa*p.z;
    r.y = p.y;
    r.z = -sa*p.x + ca*p.z;
    return r;
}

// distance to scene
float scene(vec3 p)
{
    float d = 1e10;

   p += vec3(1.5);
   p = mod(p, 4.0);
   p -= vec3(2.5);

   // body
//   d = sphere(p, 1.0);
   d = sphere(p*vec3(4.0, 4.0, 1.0), 1.0)*0.25;

   // mouth
   d = difference(d, box(p - vec3(0.0, 0.0, 1.0), vec3(0.2, 0.01, 0.2)));
//   d = difference(d, sphere(p*vec3(1.0, 10.0, 1.0) - vec3(0.0, 0.0, 0.95), 0.15)*0.1);

   // eyes
   d = _union(d, sphere(p-vec3(0.08, 0.08, 0.85), 0.06));
   d = _union(d, sphere(p-vec3(-0.08, 0.08, 0.85), 0.06));

   d = _union(d, sphere(p-vec3(0.08, 0.1, 0.88), 0.04));
   d = _union(d, sphere(p-vec3(-0.08, 0.1, 0.88), 0.04));

   // fins
   float f;
   f = box(p, vec3(1.2, 0.02, 0.2));
   f = _union(f, box(p, vec3(0.02, 1.2, 0.2)));

   f = intersect(f, sphere(p - vec3(0.0, 0.0, -1.8), 2.0));

   d = _union(f, d);

   // tail
   d = _union(d, box(p + vec3(0.0, 0.0, 1.0), vec3(0.02, 0.25, 0.25)));
   d = difference(d, sphere(p + vec3(0.0, 0.0, 1.25), 0.25));

   return d;
}

// calculate scene normal
vec3 sceneNormal( in vec3 pos )
{
    float eps = 0.0001;
    vec3 n;
    n.x = scene( vec3(pos.x+eps, pos.y, pos.z) ) - scene( vec3(pos.x-eps, pos.y, pos.z) );
    n.y = scene( vec3(pos.x, pos.y+eps, pos.z) ) - scene( vec3(pos.x, pos.y-eps, pos.z) );
    n.z = scene( vec3(pos.x, pos.y, pos.z+eps) ) - scene( vec3(pos.x, pos.y, pos.z-eps) );
    return normalize(n);
}

// ambient occlusion approximation
float ambientOcclusion(vec3 p, vec3 n)
{
    const int steps = 3;
    const float delta = 0.5;

    float a = 0.0;
    float weight = 1.0;
    for(int i=1; i<=steps; i++) {
        float d = (float(i) / float(steps)) * delta;
        a += weight*(d - scene(p + n*d));
        weight *= 0.5;
    }
    return clamp(1.0 - a, 0.0, 1.0);
}

// smooth pulse
float pulse(float a, float b, float w, float x)
{
    return smoothstep(a, a + w, x) - smoothstep(b - w, b, x);
}

// lighting
vec3 shade(vec3 pos, vec3 n, vec3 eyePos)
{
    const vec3 lightPos = vec3(4.0, 10.0, 4.0);
//    const vec3 color = vec3(0.643, 0.776, 0.223);
//    const vec3 color = vec3(1.0, 0.3, 0.0);
    const float shininess = 400.0;

    vec3 l = normalize(lightPos - pos);
    vec3 v = normalize(eyePos - pos);
    vec3 h = normalize(v + l);
    float ndotl = dot(n, l);
    float spec = max(0.0, pow(dot(n, h), shininess)) * float(ndotl > 0.0);
    //float diff = max(0.0, ndotl);
    float diff = 0.5+0.5*ndotl;

    float fresnel = pow(1.0 - dot(n, v), 5.0);
    float ao = ambientOcclusion(pos, n);

#if 1
    // stripes
    float sx = pulse(0.0, 0.5, 0.1, fract(pos.t*15.0));
   //float a = atan2(pos.y, pos.x) / 3.1415;
   //a -= 0.1;
   //float sx = pulse(0.0, 0.5, 0.1, frac(a*8.0));

    float w = 0.5;
    //float w = 1.1-diff;
    //float w = smoothstep(0.25, -0.25, pos.y);
    //float w = 1.0 - (pos.y + 0.25)*2.0;
    float sz = pulse(0.0, w, 0.1, fract(pos.z*20.0)) * ((w > 0.1) ? 1.0 : 0.0);

    vec3 color = mix(vec3(1.0), vec3(1.0, 0.3, 0.0), sx) * vec3(1.0-sz);
#else
    const vec3 color = vec3(0.9, 0.25, 0.0);
#endif

    return vec3(diff*ao) * color + vec3(spec + fresnel*0.5);
//    return vec3(diff*ao) * color + vec3(spec);
//    return vec3(diff) * color + vec3(spec);
//    return vec3(diff);
//    return vec3(ao);
//    return vec3(fresnel);
}

// trace ray using sphere tracing
vec3 trace(vec3 ro, vec3 rd, out bool hit)
{
    const int maxSteps = 128;
    const float hitThreshold = 0.001;
    hit = false;
    vec3 pos = ro;

    for(int i=0; i<maxSteps; i++)
    {
        float d = scene(pos);
        if (d < hitThreshold) {
            hit = true;
            //return pos;
        }
        pos += d*rd;
    }
    return pos;
}

vec3 background(vec3 rd)
{
     //return mix(vec3(1.0), vec3(0.0), rd.y);
     return mix(vec3(1.0), vec3(0.0), abs(rd.y));
     //return vec3(0.0);
}

void main(void)
{
    vec2 pixel = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;

    // compute ray origin and direction
    float asp = resolution.x / resolution.y;
    vec3 rd = normalize(vec3(asp*pixel.x, pixel.y, -3.0));
    vec3 ro = vec3(0.0, 0.0, 4.0);

    float rx = -0.4;
    float ry = time*0.1;
    ro = rotateX(ro, rx);
    ro = rotateY(ro, ry);
    rd = rotateX(rd, rx);
    rd = rotateY(rd, ry);

    // trace ray
    bool hit;
    vec3 pos = trace(ro, rd, hit);

    vec3 rgb;
    if(hit)
    {
        // calc normal
        vec3 n = sceneNormal(pos);
        // shade
        rgb = shade(pos, n, ro);

     } else {
        rgb = background(rd);
     }

   // fog
   float d = length(pos)*0.07;
   float f = exp(-d*d);

    // vignetting
    rgb *= 0.5+0.5*smoothstep(2.0, 0.5, dot(pixel, pixel));

//    gl_FragColor=vec4(rgb, 1.0);	
    gl_FragColor=vec4(mix(vec3(1.0, 0.9, 0.7), rgb, f), 1.0);
}
