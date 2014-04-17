precision mediump float;uniform vec2 resolution;vec2 Y=resolution;vec3 v=vec3(0
),s=vec3(0,1,0),f=vec3(1),e,y,z,x,c,n,i,r,d,g,o;float m,u,t,l,a=1e30,q=0.,F=1.,
C=.5,Z;void X(vec3 d){v=y-d;t=dot(v,z),m=t*t-(dot(v,v)-C*C);m=-t-sqrt(m>0.?m:a)
;if(m>q)x=y+z*m,c=x-d,Z=m;}void X(){Z=a;X(vec3(1,0,-2.2));X(vec3(-2,0,-3.5));X(
vec3(-.5,0,-3));m=-(y.y+C)/z.y;if(m>q&&m<Z)x=y+z*m,c=s,Z=m;}void main(){o=vec3(
-F+2.*gl_FragCoord.xy/Y,0);y=v,z=normalize(vec3(Y.x/Y.y*o.x,o.y,-1));X();i=vec3
(Z<1e9?1:0);n=r=x+1e-5,g=c,d=normalize(cross(f,g));f=normalize(cross(g,d));for(
int t=0;t<36;++t){m+=r.x+=r.y*53.+r.z*21.;m=sin(cos(m)*m)*C+C;u=mod(m*33e3+626.
,53.)/53.;m=18.7e3*u;l=sqrt(F-u);c=vec3(cos(m)*l,sin(m)*l,sqrt(u));y=n;z=vec3(c
.x*d.x+c.y*f.x+c.z*g.x,c.x*d.y+c.y*f.y+c.z*g.y,c.x*d.z+c.y*f.z+c.z*g.z);X();if(
Z<1e9)e+=F;}gl_FragColor=vec4((36.-e)/36.*i,1);}