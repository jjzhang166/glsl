#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


struct Ray{
    vec3 org;
    vec3 dir;
};

struct Intersection{
    float t;
    vec3 p;
    vec3 n;
    int hit;
    vec3 col;
};


float sdPlane( vec3 p, vec4 n )
{
  // n must be normalized
  return dot(p,n.xyz) + n.w;
}

float distanceFunctionPlane(vec3 p){
    return sdPlane(p.xyz, normalize(vec4(0.0, 1.0, 0.0, 4.0)));
}

vec3 colFunctionPlane(vec3 p){
    return vec3(0., 0., 0.8);
}

vec3 getNormalPlane(vec3 p){
    const float d = 0.0001;
    return
        normalize
        (
         vec3
         (
          distanceFunctionPlane(p+vec3(d,0.0,0.0))-distanceFunctionPlane(p+vec3(-d,0.0,0.0)),
          distanceFunctionPlane(p+vec3(0.0,d,0.0))-distanceFunctionPlane(p+vec3(0.0,-d,0.0)),
          distanceFunctionPlane(p+vec3(0.0,0.0,d))-distanceFunctionPlane(p+vec3(0.0,0.0,-d))
         )
        );
}

vec3 trans(vec3 p)
{
    return vec3(p.xy, mod(p.z, 2.0)-1.0);
}

float sdTorus( vec3 p, vec2 t )
{
    vec2 q = vec2(length(p.xz)-t.x,p.y);
    return length(q)-t.y;
}
float rotatedTorus(vec3 p, vec2 t){
    mat4 m = mat4(0.0);
    m[0][0] = 1.;
    m[1][2] = 1.;
    m[2][1] = 1.;
    m[3][3] = 1.;
    vec4 q = m*vec4(p, 1);
    return sdTorus(q.xyz, t);
}

float distanceFunction(vec3 pos)
{
    return rotatedTorus(trans(pos), vec2(1, 0.3));
}

vec3 colFunction(vec3 pos){
    float a = mod(pos.z, 6.0);
    if(a < 2.0){
        return vec3(0., 0.8, 0.8);
    }else if(a < 4.0){
        return vec3(0.8, 0., 0.);
    }else{
        return vec3(0.8, 0.8, 0.8);
    }
}

vec3 getNormal(vec3 p)
{
    const float d = 0.0001;
    return
        normalize
        (
         vec3
         (
          distanceFunction(p+vec3(d,0.0,0.0))-distanceFunction(p+vec3(-d,0.0,0.0)),
          distanceFunction(p+vec3(0.0,d,0.0))-distanceFunction(p+vec3(0.0,-d,0.0)),
          distanceFunction(p+vec3(0.0,0.0,d))-distanceFunction(p+vec3(0.0,0.0,-d))
         )
        );
}

Intersection Intersect(Ray ray){
    Intersection i;
    i.hit = 0;
    i.t = 1.0e+30;
    i.col = vec3(0.0, 0.0, 0.0);

    float t = 0.0, d;
    vec3 posOnRay = ray.org;
    for(int i=0; i<20; ++i)
    {
        d = min(distanceFunction(posOnRay), distanceFunctionPlane(posOnRay));
        t += d;
        posOnRay = ray.org + t*ray.dir;
    }
    if(abs(d) > 0.001){
        for(int i=0; i<50; ++i)
        {
            d = min(distanceFunction(posOnRay), distanceFunctionPlane(posOnRay));
            t += d;
            posOnRay = ray.org + t*ray.dir;
        }
    }
    if(abs(distanceFunctionPlane(posOnRay)) < 0.001){
        i.n = getNormalPlane(posOnRay);
        if(abs(d) < 0.001){
            i.t = t;
            i.hit = 1;
            i.col = colFunctionPlane(posOnRay);
        }
    }else if(abs(distanceFunction(posOnRay)) < 0.001){
        i.n = getNormal(posOnRay);
        if(abs(d) < 0.001){
            i.t = t;
            i.hit = 1;
            i.col = colFunction(posOnRay);
        }
    }
    i.p = posOnRay;
    return i;
}

float computedShadow(Intersection i){
    float eps = 0.05;

    float shadow = 1.0;
    
    vec3 lightDir = vec3(1., 1., 1.);
    if(dot(i.n, lightDir) > 0. || true){
        Ray rsh;
        rsh.dir = lightDir;
        rsh.org = i.p + i.n * eps;
        Intersection ish = Intersect(rsh);
        shadow -= float(ish.hit);
    }else{
        shadow = 0.0;
    }
    return shadow;
}

void main() {
    vec2 pos = (gl_FragCoord.xy*2.0 -resolution) / resolution.y;

    vec3 camPos = vec3(0.0, 0.0, time * 3.);
    vec3 camDir = vec3(sin(time), 0.0, cos(time));
    vec3 camUp = vec3(0.0, 1.0, 0.0);
    vec3 camSide = cross(camDir, camUp);
    float focus = 1.8;
    vec3 rayDir = normalize(camSide*pos.x + camUp*pos.y + camDir*focus);
    
    Ray ray;
    ray.org = camPos;
    ray.dir = rayDir;
    
    float eps = 0.001;
    
    
    vec4 col = vec4(0., 0., 0., 1.);
    vec3 bcol = vec3(1.,1.,1.);
    const int raytraceDepth = 2;
    for(int j = 0; j < raytraceDepth; j++){
        Intersection i = Intersect(ray);
        if(i.hit != 0){
            float shadow = computedShadow(i);
            //col.rgb += bcol * i.col * shadow;
            col.rgb = 1.0 - (1.0 - col.rgb) * (1.0 - bcol * i.col * shadow);
            bcol *= i.col;
        }else{
            break;
        }
        ray.org = i.p + i.n * eps;
        ray.dir = reflect(ray.dir, i.n);
    }

    gl_FragColor = col;
}
