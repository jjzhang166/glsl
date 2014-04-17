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



// objects

float box(vec3 p, vec3 abc )

{

    vec3 di=max(abs(p)-abc, vec3(0.0));

    //return dot(di,di);

    return length(di);

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



float tet(vec3 z)

{

        const int iterations = 10;

        const float scale = 2.0;



     vec3 a1 = vec3(1,1,1);

     vec3 a2 = vec3(-1,-1,1);

     vec3 a3 = vec3(1,-1,-1);

     vec3 a4 = vec3(-1,1,-1);

     vec3 c;

     float dist, d;

     int i = 0;

     //while(n < iterations) {

     for(int n=0; n < iterations; n++) {

          c = a1; dist = length(z-a1);

          d = length(z-a2); if (d < dist) { c = a2; dist=d; }

          d = length(z-a3); if (d < dist) { c = a3; dist=d; }

          d = length(z-a4); if (d < dist) { c = a4; dist=d; }

          z = scale*z-c*(scale-1.0);

          i++;

     }



     return (length(z)-2.0) * pow(scale, float(-i));

}



// optimized version using folds

float tet2(vec3 z)

{

    const int iterations = 10;

    const float scale = 2.0;

    //float scale = 2.0+sin(time);



    float r;

    //float s = 1.0;

    int c = 0;

    for(int n = 0; n < iterations; n++) {

    //while(n < iterations) {

       if(z.x+z.y<0.0) z.xy = -z.yx; // fold 1

       if(z.x+z.z<0.0) z.xz = -z.zx; // fold 2

       if(z.y+z.z<0.0) z.yz = -z.zy; // fold 3

       z = z*scale - (scale-1.0);

       //r = dot(z, z);

       //s = s * scale;

       c++;

    }

    return (length(z)-2.0 ) * pow(scale, -float(c));

    //return length(z) / s;

}



// distance to scene

float scene(vec3 p)

{

    float d;



    // floor plane

    //d = plane(p, vec3(0.0, 1.0, 0.0), vec3(0.0, -1.0, 0.0));

    d = p.y + 1.0;



    // repeat

    p = mod(p + vec3(1.0), 2.0) - vec3(1.0);



    //d = min(d, box(p, 0.5));

    //d = min(d, difference(box(p, 0.5), sphere(p, 0.7)));



    d = min(d, tet2(p));



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



// lighting

vec3 shade(vec3 pos, vec3 n, vec3 eyePos)

{

    //const vec3 lightPos = vec3(5.0, 10.0, 5.0);

    //const vec3 color = vec3(0.643, 0.776, 0.223);

    //const float shininess = 100.0;



    //vec3 l = normalize(lightPos - pos);

    vec3 l = vec3(0.0, 0.0, 1.0);

    //vec3 v = normalize(eyePos - pos);

    //vec3 h = normalize(v + l);

    float diff = dot(n, l);

    //float spec = max(0.0, pow(dot(n, h), shininess)) * float(diff > 0.0);

    //diff = max(0.0, diff);

    diff = 0.5+0.5*diff;



    //float fresnel = pow(1.0 - dot(n, v), 5.0);

    float ao = ambientOcclusion(pos, n);



//    return vec3(diff*ao) * color + vec3(spec + fresnel*0.5);

//    return vec3(diff*ao) * color + vec3(spec);

//    return diff;

//    return vec3(ao);

   return vec3(diff*ao);

//     return lerp(vec3(1.0), vec3(diff*ao), fog);

//    return vec3(fresnel);

}



// trace ray using sphere tracing

vec3 trace(vec3 ro, vec3 rd, out bool hit)

{

    const int maxSteps = 128;

    const float hitThreshold = 0.01;

    hit = false;

    vec3 pos = ro;



    for(int i=0; i<maxSteps; i++)

    {

        float d = scene(pos);

        if (d < hitThreshold) {

            hit = true;

            return pos;

        }

        pos += d*rd;

    }

    return pos;

}



vec3 background(vec3 rd)

{

     //return mix(vec3(1.0), vec3(0.0), rd.y);

     //return mix(vec3(1.0), vec3(0.0, 0.25, 1.0), rd.y);

     return vec3(0.0);

}



void main(void)

{

    vec2 pixel = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;



    // compute ray origin and direction

    float asp = resolution.x / resolution.y;

    vec3 rd = vec3(asp*pixel.x, pixel.y, -2.0);



    // fish-eye

    rd.z = -sqrt(2.0 - dot(rd.xy, rd.xy));

    rd = normalize(rd);



    // move camera

    //vec3 ro = vec3(0.0, 0.0, 4.0);

    //vec3 ro = vec3(0.0, 0.3, 2.0+2.0*sin(time*0.25));

    vec3 ro = vec3(time*0.25, 0.3, time*0.25);



    float a;

    //a = sin(time*0.3)*1.5;

    a = time*0.3;

    rd = rotateY(rd, a);

    //ro = rotateY(ro, a);



    float ax = sin(time*0.1)*0.25;

    rd = rotateX(rd, ax);

    //ro = rotateX(ro, ax);    



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



        // fog

        float dist = length(pos - ro)*0.25;

        float fog = exp(-dist*dist);

        //rgb = fog;

        //rgb = lerp(vec3(1.0), rgb, fog);

        rgb *= fog;





#if 0

        // reflection

        vec3 v = normalize(ro - pos);

        float fresnel = 0.1 + 0.4*pow(1.0 - dot(n, v), 5.0);



        ro = pos + n*0.01; // offset to avoid self-intersection

        rd = reflect(-v, n);

        pos = trace(ro, rd, hit);



        if (hit) {

            vec3 n = sceneNormal(pos);

            rgb += shade(pos, n, ro) * vec3(fresnel);

        } else {

            rgb += background(rd) * vec3(fresnel);

        }

#endif 



     } else {

        rgb = background(rd);

     }



    // vignetting

    //rgb *= 0.5+0.5*smoothstep(2.0, 0.5, dot(pixel, pixel));



    gl_FragColor=vec4(rgb, 1.0);

}
