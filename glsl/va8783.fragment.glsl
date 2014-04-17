#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main(void)
{
    vec2 uv = -1.0+gl_FragCoord.xy / resolution.xy*2.0;

    vec3 c = vec3(0.0);

    float a = dot( uv, vec2 ( uv * 2.0 ) );

    float r = step(a, 0.5);

    if(r*r>a)
    {
        c = vec3(1.0,0.0,0.0) * uv.y ;

        if(uv.y  < 0.5) {
            c += uv.x*uv.y*sin(time);
            c-=0.20;
        }
    }

    gl_FragColor = vec4(c,1.0)*2.0;
}