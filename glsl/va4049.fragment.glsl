precision highp float;
#define MAX_ITER 100

uniform float time;
uniform vec2 resolution;



float f(vec3 o)
{
    float a=(sin(o.x)+o.y*0.25)*0.25;
    o=vec3(cos(a)*o.x-sin(a)*o.y,sin(a)*o.x+cos(a)*o.y,o.z);
    return dot(cos(o)*cos(o),vec3(1))-1.2;
}

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
	
    if( nh>0.0 ) return vec3(.0,.0,.0);
	
    t = t - dt*nh/(nh-lh);
	
    vec3 e=vec3(.1,0.0,0.0);
    vec3 p=o+d*t;
    vec3 n=-normalize(vec3(f(p+e),f(p+e.yxy),f(p+e.yyx))+vec3((sin(p*75.)))*0.1);
	
    return vec3( mix( ((max(-dot(n,vec3(.577)),0.) + 0.125*max(-dot(n,vec3(-.707,-.707,0)),0.)))*(mod
//		(length(p.xy)*20.,2.)<1.0?vec3(2.2,1.31,3.54):vec3(.79,.93,.4))
		(length(p.xy)*20.,2.)<1.0?vec3(2.2,1.31,3.54):vec3(.0,.0,.0))
//		,vec3(.0,.0,.0), vec3(pow(t/9.,5.)) ) );
					 ,vec3(.93,.94,.85), vec3(pow(t/9.,5.)) ) );
}


void main()
{
    vec2 p = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
    gl_FragColor=vec4(s(vec3(sin(time*1.5)*.5,cos(time)*0.5,time), normalize(vec3(p.xy,1.0))),1.0);
}