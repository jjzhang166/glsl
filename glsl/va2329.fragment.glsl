#ifdef GL_ES
precision highp float;
#endif

//tigrou(ind) 2012.04.27 add checkers + phong shading

uniform vec2 resolution;
uniform float time;

float h(vec3 q)
{
    float f=1.*distance(q,vec3(cos(time)+sin(time*.2),.3,2.+cos(time*.5)*.5));
    f*=distance(q,vec3(-cos(time*.7),.3,2.+sin(time*.5)));
    f*=distance(q,vec3(-sin(time*.2)*.5,sin(time),2.));
    f*=cos(q.y)*cos(q.x)-.1-cos(q.z*7.+time*7.)*cos(q.x*3.)*cos(q.y*4.)*.1;
    return f;
}

vec3 l(vec3 n, vec3 l, vec3 d, vec3 lc)
{ 
   l = normalize(l);
   float la =  max(dot(n,l),0.0);
   la = pow(la, 3.0);
   vec3 r =  reflect(-l, n); 
   float sp = max(dot(r, l), 0.0);
   sp = pow(sp, 50.0);
   return d * lc * la + lc * sp;            
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
            
		
            vec3 p=o+d*t;
	    n=normalize(n);
            float s = (sign(sin(p.x*5.0)*cos(p.y*5.0)*sin(p.z*5.0))+1.0)*0.5;
	
	    c=vec4(l(n, vec3(.0,-.5,.5),  mix(vec3(0.8, 0.5, 0.0),vec3(0.5, 0.0, 0.1),s),vec3(1.0, 1.0, 1.0)),1.0);
	    
	    
	    
            break;
        }
        t+=5.;
    }
    gl_FragColor=c+vec4(.1,.1,.1,1.)*(t*.025);
}