#ifdef GL_ES
precision highp float;
#endif
//metatunnel ripoff/fork, by anony_gt
uniform vec2 resolution;
uniform float time;

float h(vec3 q)
{
    float f=1.*distance(q,vec3(cos(time)+sin(time*2.3),.01,1.+cos(time*1.5)*.1));
    f*=distance(q,vec3(cos(time*.1),.5,2.+cos(time*.5)));
    f*=distance(q,vec3(sin(time*.1)*.1,sin(time),.3));
    f*=cos(q.y)*cos(q.x)-(tan(q.z+time*.5))*2.3*cos(q.x*23.)*sin(q.y*1.)*.5;
    return f;
}

void main()
{
    vec2 p = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
    vec3 o=vec3(p.x,p.y*1.25-0.3,0.);
    vec3 d=vec3(p.x+cos(time)*0.3,p.y,1.)/64.;
    vec4 c=vec4(0.);
    float t=0.;
    for(int i=0;i<75;i++)
    {
        if(h(o+d*t)<.4)
        {
            t-=5.;
            for(int j=0;j<5;j++)
            {
                if(h(o+d*t)<.4)
                    break;
                t+=1.;
            }
            vec3 e=vec3(.01,.0,.0);
            vec3 n=vec3(.0);
            n.x=h(o+d*t)-h(vec3(o+d*t+e.xyy));
            n.y=h(o+d*t)-h(vec3(o+d*t+e.yxy));
            n.z=h(o+d*t)-h(vec3(o+d*t+e.yyx));
            n=normalize(n);
            c+=max(dot(vec3(.0,.0,-.5),n),.0)+max(dot(vec3(.0,-1.5,.5),n),.0)*.5;
            break;
        }
        t+=5.;
    }
    gl_FragColor=c+vec4(.5,.2,.1,1.)*(t*.025);
}
