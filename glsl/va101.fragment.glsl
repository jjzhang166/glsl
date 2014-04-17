// by tigrou
// Obnoxious blurry effects by MidKnight|Centigonal
// Testing new stuff

#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform float time;
uniform sampler2D backbuffer;

// Backbuffer fetch
vec4 bbf(vec2 pos)
{
    return texture2D( backbuffer, pos );
}

float f(vec3 o)
{
    float a=(sin(o.x)+o.y*.25)*.35;
    o=vec3(cos(a)*o.x-sin(a)*o.y,sin(a)*o.x+cos(a)*o.y,o.z);
    return dot(cos(o)*cos(o),vec3(1))-1.2;
}

#if 0
//
// modified by iq:
//   removed the break inside the marching loop (GLSL compatibility)
//   replaced 10 step binary search by a linear interpolation
//
vec3 s(vec3 o,vec3 d)
{
    float t=0.0;
    float dt = 0.2;
    float nh = 0.0;
    float lh = 0.0;
    for(int i=0;i<50;i++)
    {
        nh = f(o+d*t);
        if(nh>0.0) { lh=nh; t+=dt; }
    }

    if( nh>0.0 ) return vec3(.93,.94,.85);

    t = t - dt*nh/(nh-lh);

    vec3 e=vec3(.1,0.0,0.0);
    vec3 p=o+d*t;
    vec3 n=-normalize(vec3(f(p+e),f(p+e.yxy),f(p+e.yyx))+vec3((sin(p*75.)))*.01);

    return vec3( mix( ((max(-dot(n,vec3(.577)),0.) + 0.125*max(-dot(n,vec3(-.707,-.707,0)),0.)))*(mod

(length(p.xy)*20.,2.)<1.0?vec3(.71,.85,.25):vec3(.79,.93,.4))
                           ,vec3(.93,.94,.85), vec3(pow(t/9.,5.)) ) );
}
#else
//
// original marching
//
vec3 s(vec3 o,vec3 d)
{
    float t=0.,a,b;
    for(int i=0;i<75;i++)
    {
        if(f(o+d*t)<0.0)
        {
            a=t-.125;b=t;
            for(int i=0; i<10;i++)
            {
                t=(a+b)*.5;
                if(f(o+d*t)<0.0)
                    b=t;
                else
                    a=t;
            }
            vec3 e=vec3(.9,0.0,0.0);
            vec3 p=o+d*t;
            vec3 n=-normalize(vec3(f(p+e),f(p+e.yxy),f(p+e.yyx))+vec3((sin(p*75.)))*.01);

            return vec3( mix( ((max(-dot(n,vec3(.577)),0.) + 0.125*max(-dot(n,vec3(-.707,-.707,0)),0.)))*(mod(length(p.xy)*20.,2.)<1.0?vec3(.71,.85,.25):vec3(.79,.93,.4))
                           ,vec3(.93,.0,.85), vec3(pow(t/9.,5.)) ) );
        }
        t+=.125;
    }
    return vec3(.93,.94,.85);
}
#endif

void main()
{
    vec2 position = gl_FragCoord.xy / resolution.xy;
    vec2 p = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
    gl_FragColor=vec4(s(vec3(sin(time*1.5)*.5,sin(time)*.5,time), normalize(vec3(p.xy,1.0))),1.0);

    float stime = sin(time*1.5+.4);
    vec2 newpos1 = vec2(position.x+0.001, position.y+0.001);
    vec2 newpos2 = vec2(position.x-0.0001, position.y-0.0001);
    vec2 newpos3 = vec2(position.x+0.0001, position.y-0.0001);
    vec2 newpos4 = vec2(position.x-0.0001, position.y+0.0001);
    vec4 finalNewPos = (bbf(newpos1) + bbf(newpos2) + bbf(newpos3) + bbf(newpos4))/vec4(4);

    vec4 colorVec = vec4((.1*(stime))+0.75,(0.4*stime)+0.4,0.,1);
    gl_FragColor = mix( gl_FragColor, bbf( position )* colorVec, (0.2*(1.0-stime))+0.3) ;
    gl_FragColor = mix( gl_FragColor,  finalNewPos , 0.87 ) ;
    // Alpha, for the gallery screenshot.
    gl_FragColor.a = 1.0;
}
