#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;

float h(vec3 q)
{
    float f=1.*distance(q,vec3(cos(time)+sin(time*.22),.11,12.+cos(time*.1)*.15));
    f*=distance(q,vec3(-cos(time*.17),.13,12.+sin(time*.115)));
    f*=distance(q,vec3(-sin(time*.21)*.5,sin(time),2.));
    f*=cos(q.y)*cos(q.x)-.1-cos(q.z*17.+time*4.11)*cos(q.x*12.)*cos(q.y*11.)*.1;
    return f;
}

void main()
{
    vec2 p = -1.30 + 2.0 * gl_FragCoord.xy / resolution.xy;
    vec3 o=vec3(p.x,p.y*0.01-0.3,0.);
    vec3 d=vec3(p.x+cos(time)*0.3,p.y,1.)/64.;
    vec4 c=vec4(0.);
   
    float color;
  
    
  float t=1.;
    for(int i=10;i<12;i++)
    {
        if(h(o+d*t)<.4)
        {
            t-=10.;
            for(int j=0;j<1;j++)
            {
                if(h(o+d*t)<.1)
                   // break;
                t+=10.;
            }
            vec3 e=vec3(color);
            vec3 n=vec3(.02);
            n.x=h(o+d*t)-h(vec3(o+d*t+e.xyy));
            n.y=h(o+d*t)-h(vec3(o+d*t+e.yxy));
            n.z=h(o+d*t)-h(vec3(o+d*t+e.yyx));
            n=normalize(n);
            c+=max(dot(vec3(.0,.0,-.5),n),.0)+max(dot(vec3(.0,-.5,.5),n),.0)*.15;
            break;
        }
        t+=100.;
    }
    gl_FragColor=c+vec4(.1,.2,.5,1.)*(t*.025);
}