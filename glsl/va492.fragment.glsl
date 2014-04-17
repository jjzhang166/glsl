#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform float time;

float h(vec3 q)
{
    float f=1.*distance(q,vec3(cos(time)+sin(time*.2),.3,2.+cos(time*.5)*.5));
    f*=distance(q,vec3(-cos(time*.7),.3,2.+sin(time*.5)));
    f*=distance(q,vec3(-sin(time*.2)*.5,sin(time),2.));
    f*=cos(q.y)*cos(q.x)-.1-cos(q.z*7.+time*7.)*sin(q.x*3.)*cos(q.y*4.)*.1;
    return f;
}

float v(vec3 q)
{
    float f=1.*dot(q,vec3(cos(time)+sin(time*q.x),q.y,2.+tan(time*q.y)*.15));
    f-=distance(q,vec3(cos(time*7.),.3,2.+-sin(time*.5)));
    f*=dot(q,vec3(-sin(time*0.4)*.5,tan(time),0.5));
    f*=tan(q.y)*cos(q.x)-.1-sin(q.z*7.+time*7.)*sin(q.x*q.z)*tan(q.y*4.)*.01;
    return f;
}

void main()
{
    vec2 p = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
    vec3 o=vec3(p.y,p.x,0.) * v(vec3(time * .001, -time * .001, 0.));
    vec3 d=vec3(p.x+tan(time)*0.3,p.y,10.);
    vec4 c=vec4(0.2);
    float t=0.4;
    for(int i=0;i<50;i++)
    {
        if(h(o+d*t)<.4)
        {
            t-=100.;
            vec3 e=vec3(.01,.0,.0);
            vec3 n=vec3(.0);
            n.x=h(o+d*t)-h(vec3(o+d*t+e.xyy));
            n.y=h(o+d*t)-h(vec3(o+d*t+e.yxy));
            n.z=h(o+d*t)-h(vec3(o+d*t+e.yyx));
            n=normalize(n);
            c+=max(dot(vec3(.0,.0,-.5),n),.0)+min(dot(vec3(.0,-.5,.5),n),.0);
            break;
        }
        t+=5.;
    }
    gl_FragColor=c;
}