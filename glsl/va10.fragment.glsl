// by @twbompo

#ifdef GL_ES
precision lowp float;
#endif

uniform vec2 resolution;
uniform float time;
float et = time / 10.0;
float v;
vec3 n;
vec2 e;
vec3 f=vec3(.95,.95,.95);
mat3 i,m,r,y;
vec2 c;
float x=1.651,t=1./sqrt(pow(x*(1.+x),2.)+pow(x*x-1.,2.)+pow(1.+x,2.)),z=x*(1.+x)*t,s=(x*x-1.)*t,w=(1.+x)*t;
vec3 a=vec3(.5,.5/x,.5*x),p=vec3(z,s,w);
vec3 l(vec3 v) {
    vec3 n;
    n=vec3(.5,0.5,.5);
    float e=3.;
    v*=i;
    float f,x,c=100.,y=0.;
    for(int z=0;z<8;z++) {
        v*=m;
        v=abs(v);
        x=v.x*a.z+v.y*a.y-v.z*a.x;
        if(x<0.)
            v+=vec3(-2.,-2.,2.)*x*a.zyx;
        x=-v.x*a.x+v.y*a.z+v.z*a.y;
        if(x<0.)
            v+=vec3(2.,-2.,-2.)*x*a.xzy;
        x=v.x*a.y-v.y*a.x+v.z*a.z;
        if(x<0.)
            v+=vec3(-2.,2.,-2.)*x*a.yxz;
        x=-v.x*p.x+v.y*p.y+v.z*p.z;
        if(x<0.)
            v+=vec3(2.,-2.,-2.)*x*p.xyz;
        x=v.x*p.z-v.y*p.x+v.z*p.y;
        if(x<0.)
            v+=vec3(-2.,2.,-2.)*x*p.zxy;
        v*=r;
        v*=e;
        v-=n*(e-1.);
        f=dot(v,v);
        if(z<4)
            c=min(c,f),y=f;
    }
    return vec3((length(v)-2.)*pow(e,-8.),c,y);
}
vec3 b(vec2 x) {
    vec2 n=(.5*e-x)/vec2(e.x,-e.y);
    n.x*=e.x/e.y;
    vec3 a=n.x*vec3(1,0,0)+n.y*vec3(0,1,0)-v*vec3(0,0,1);
    return normalize(y*a);
}
float b(vec3 e,vec3 x,float v) {
    float n=1.;
    v*=10.6;
    float t=.16/v,y=2.*v;
    for(int i=0;i<5;++i)
        n-=(y-l(e+x*y).x)*t,y+=v,t*=.5;
    return clamp(n,0.,1.);
}
vec4 h(vec2 x) {
    vec3 a=b(x);
    float i=0.0;
    vec3 y;
    float c=0.0;
    vec3 m,z=vec3(0);
    int r=0;
    bool t=false;
    float w=25.,p=2.*(1./sqrt(1.+v*v))*(1./min(e.x,e.y))*1.22;
    y=n+i*a;
    for(int gg=0;gg<90;gg++) {
        r=gg;
        m=l(y);
        m.x*=.6;
        if(t&&m.x<c||i>w) {
            break;
        }
        t=false;
        i+=m.x;
        y=n+i*a;
        c=i*p;
        if(m.x<c) {
            t=true;
	    break;
	}
    }
    vec4 g=vec4(f,.9);
    if(t) {
        float d=1.;
        if(r<1||i<s)
            z=normalize(y);
        else {
            float h=max(c*.5,1.5e-07);
            z=normalize(vec3(l(y+vec3(h,0,0)).x-l(y-vec3(h,0,0)).x,l(y+vec3(0,h,0)).x-l(y-vec3(0,h,0)).x,l(y+vec3(0,0,h)).x-l(y-vec3(0,0,h)).x));
            d=b(y,z,c);
        }
        float h=max(dot(z,normalize(vec3(-66,162,-30)-y)),0.);
        g.xyz=(mix(vec3(.5),f,.3)*vec3(.45)+vec3(.45)*h+pow(h,4.)*.8)*d;
        g.w=1.;
    }
    g.xyz=mix(f,g.xyz,exp(-pow(i,2.)*.01));
    return g;
}
mat3 g(float e) {
    return mat3(vec3(1.,0.,0.),vec3(0.,cos(e),sin(e)),vec3(0.,-sin(e),cos(e)));
}
mat3 d(float e) {
    return mat3(vec3(cos(e),0.,-sin(e)),vec3(0.,1.,0.),vec3(sin(e),0.,cos(e)));
}
vec4 D(vec2 x) {
    mat3 a=mat3(1,0,0,0,1,0,0,0,1);
    float t=sin(.1*et),z=cos(.1*et);
    mat3 p=mat3(vec3(z,t,0.),vec3(-t,z,0.),vec3(0.,0.,1.));
    vec2 f;
    float s,w;
    f=c.xy;
    v=1.;
    n=vec3(0.,0.,-2.2),w=0.;
    i=g(.1*et)*d(.1*et)*p*a;
    m=g(et)*a;
    r=g(w)*a;
    y=d(3.14)*a;
    vec4 l=h(f);
    if(l.w<0.00392) {
        discard;
    }
    return l;
}
void main() {
    vec2 v =resolution;
    e=v;
    c=gl_FragCoord.xy;
    vec4 n;
    n=D(c.xy);
     
    vec3 x=n.xyz;
    x*=vec3(0.9,0.9,0.9);
    
    gl_FragColor=vec4(x,1.);    
}