#ifdef GL_ES
precision highp float;
#endif
//agt_fucking up the clod
uniform vec2 resolution;
uniform vec2 mouse;
uniform float time;

float f(vec3 o)
{
  o.x=sin(o.x+0.5)-0.5;
  o.z=sin(o.z+0.5)-0.5-(mouse.y-.5);
  o.y=sin(o.y+0.5)-0.5-(mouse.x-.5);
  vec3 q = vec3(length(o.xyz)-(1.9));
  return vec3(0.0),0.0,(length(q)-0.07);

}

#if 1
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
            vec3 e=vec3(.1,0.0,0.0);
            vec3 p=o+d*t;
            vec3 n=-normalize(vec3(f(p+e),f(p+e.yxy),f(p+e.yyx))+vec3((sin(p*75.)))*.01);

            return vec3( mix( ((max(-dot(n,vec3(.577)),0.) + 0.125*max(-dot(n,vec3(-.707,-.707,0)),0.)))*(mod(length(p.xy)*20.,2.)<1.0?vec3(.71,.85,.25):vec3(.79,.93,.4))
                           ,vec3(.93,.94,.85), vec3(pow(t/9.,5.)) ) );
        }
        t+=.125;
    }
    return vec3(.93,.94,.85);
}
#endif

void main()
{
	vec2 p = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
	vec4 rgb=vec4(s(vec3(sin(time*.2)*.5-(mouse.x*5.)-2.25,cos(time)*.2-(mouse.y*5.)-2.5,time*.3), normalize(vec3(p.xy,1.0))),1.0);
	//vignette-reduce first value to darken
	rgb *= 0.25+0.5*smoothstep(2.0, 0.1, dot(p, p));
	gl_FragColor=vec4(rgb);
}
