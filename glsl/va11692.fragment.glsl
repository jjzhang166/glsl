#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


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
    mat3 m = mat3(0.0);
    m[0][0] = 1.0;
    m[1][2] = 1.0;
    m[2][1] = 1.0;
    vec3 q = m*p;
    return sdTorus(q, t);
}

float distanceFunction(vec3 pos)
{
    return rotatedTorus(trans(pos), vec2(1.0, 0.1));
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

void main() {
    vec2 pos = (gl_FragCoord.xy*2.0 -resolution) / resolution.y;

    vec3 camPos = vec3(0.0, 0.0, time * 3.0);
    vec3 camDir = vec3(sin(time), 0.0, cos(time));
    vec3 camUp = vec3(0.0, 1.0, 0.0);
    vec3 camSide = cross(camDir, camUp);
    float focus = 1.8;

    vec3 rayDir = normalize(camSide*pos.x + camUp*pos.y + camDir*focus);

    float t = 0.0, d;
    vec3 posOnRay = camPos;

    for(int i=0; i<64; ++i)
    {
        d = distanceFunction(posOnRay);
        t += d;
        posOnRay = camPos + t*rayDir;
    }

    vec3 normal = getNormal(posOnRay);
    if(abs(d) < 0.001)
    {
        gl_FragColor = vec4(normal, 1.0);
    }else
    {
        gl_FragColor = vec4(0.0);
    }
}
