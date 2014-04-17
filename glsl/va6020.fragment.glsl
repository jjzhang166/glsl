//======================================================================================
// Started with http://www.iquilezles.org/apps/shadertoy/?p=relieftunnel and mucked
// around with it to get this
//
// Greetz to iq/RGBA. I actually met you once at Evoke in like 2009 and you were doing
// some GPU based raytracing and it blew my mind. 
//======================================================================================
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main(void)
{
    vec2 p = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;

    float r = sqrt((p.x*p.x) + (p.y*p.y));
    float a = atan(p.y,p.x) + sin(0.5*r-0.5*time);

    float s = 0.5 + 0.5*cos(7.0*a);
    s = smoothstep(0.0,1.0,s);
    s = smoothstep(0.0,1.0,s);
    s = smoothstep(0.0,1.0,s);
    s = smoothstep(0.0,1.0,s);

    float w = (0.5 + 0.5*s)*r*r;

    vec3 col = vec3(s,0,p);

    float ao = 0.5 + 0.5*cos(7.0*a);
    ao = smoothstep(0.0,0.4,ao)-smoothstep(0.4,0.7,ao);
    ao = 1.0-0.5*ao*r;

    gl_FragColor = vec4(col*w*ao,1.0);
}