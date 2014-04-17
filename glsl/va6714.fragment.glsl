
#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform float tick;

float map(vec3 p)
{
    const int MAX_ITER = 10;
    const float BAILOUT=2.0;
    float Power = abs(sin(time/10.0)) * 20.0 + 5.;  

    vec3 v = p;
    vec3 c = v;

    float r=0.0;
    float d=1.0;
    for(int n=0; n<=MAX_ITER; ++n)
    {
        r = length(v)*1.1;
        if(r>BAILOUT) break;

        float theta = asin(v.z/r);
        float phi = atan(v.y, v.x);
        d = pow(r,Power-1.0)*Power*d+1.0;

        float zr = pow(r,Power);
        theta = theta*Power;
        phi = phi*Power;
        v = (vec3(sin(theta)*cos(phi), sin(phi)*sin(theta), cos(theta))*zr)-c;
    }
    return 0.4*log(r)*r/d;
}


void main( void )
{
    vec2 pos = (gl_FragCoord.xy*2.0 - resolution.xy) / resolution.y;
    vec3 camPos = vec3(cos(time*0.3), sin(time*0.3), 1.5);
    vec3 camTarget = vec3(0.0, 0.0, 0.0);

    vec3 camDir = normalize(camTarget-camPos);
    vec3 camUp  = normalize(vec3(0.0, 1.0, 0.0));
    vec3 camSide = cross(camDir, camUp);
    float focus = 1.0;

    vec3 rayDir = normalize(camSide*pos.x + camUp*pos.y + camDir*focus);
    vec3 ray = camPos;
    float m = 0.0;
    float d = 0.0, total_d = 0.0;
    const int MAX_MARCH = 64;
    const float MAX_DISTANCE = 5.0;
    for(int i=0; i<MAX_MARCH; ++i) {
        d = map(ray);
        total_d += d;
        ray += rayDir * d;
        m += 1.0;
        if(d<0.001) { break; }
        if(total_d>MAX_DISTANCE) { total_d=MAX_DISTANCE; break; }
    }

    float c = (total_d)*0.001;
    vec4 result = vec4( 1.0-vec3(c, c, c) - vec3(0.025, 0.025, 0.02)*m*0.8, 1.0 );
    gl_FragColor = result;
}
