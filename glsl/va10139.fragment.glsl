#define V vec3
#define N normalize
precision highp float;uniform vec2 resolution;vec2 Y=resolution;V v=V(0),s=V(0,1,0),f=V(1),e,y,z,x,c,n,i,r,d,g,o;float m,u,t,l,a=1e30,q=0.,F=1.,C=.5,Z,A=53.;
void X(V d){v=y-d;t=dot(v,z),m=t*t-(dot(v,v)-C*C);m=-t-sqrt(m>0.?m:a);if(m>q)x=y+z*m,c=x-d,Z=m;}
void X(){Z=a;X(V(1,0,-2.2));X(V(-2,0,-3.5));X(V(-.5,0,-3));m=-(y.y+C)/z.y;if(m>q&&m<Z)x=y+z*m,c=s,Z=m;}
void main(){o=V(-F+2.*gl_FragCoord.xy/Y,0);y=v,z=N(V(Y.x/Y.y*o.x,o.y,-1));X();i=V(Z<1e9?1:0);n=r=x+1e-5,g=c,d=N(cross(f,g));f=N(cross(g,d));for(int t=0;t<36;++t){
m+=r.x+=r.y*A+r.z*21.;m=sin(cos(m)*m)*C+C;u=mod(m*33e3+626.,A)/A;m=18.7e3*u;l=sqrt(F-u);c=V(cos(m)*l,sin(m)*l,sqrt(u));
y=n;z=V(c.x*d.x+c.y*f.x+c.z*g.x,c.x*d.y+c.y*f.y+c.z*g.y,c.x*d.z+c.y*f.z+c.z*g.z);X();if(Z<1e9)e+=F;}gl_FragColor=vec4((36.-e)/36.*i,1);}