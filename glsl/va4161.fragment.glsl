/**
 * Simple svg render by q
 * This is first prototype of svg render for intro(http://pouet.net/prod.php?which=60278)
 * But too heavy to wait baking time, so I used direct2d. :(
 * Please improve this!
 */

#ifdef GL_ES
precision mediump float;
#endif
uniform vec2 resolution;
#define V4 vec4
#define V3 vec3
#define V2 vec2
#define V1 float
#define IF if
#define ELF else if
#define ELS else
#define RET return
#define RT  return true;
#define RF  return false;
int modi(int i,int v)
{return int(mod(float(i),float(v)));}
V2 trans(V2 v,V1 dx,V1 dy)
{return V2(v.x-dx,v.y-dy);}
V2 rot(inout V2 v,V1 cx,V1 cy,V1 rad)
{
V1 x=v.x-cx;
V1 y=v.y-cy;
V1 cr=cos(-rad);
V1 sr=sin(-rad);
return V2(x*cr-y*sr+cx,x*sr+y*cr+cy);
}
V2 scale(V2 v,V1 cx,V1 cy,V1 s)
{return V2((v.x-cx)/s+cx,(v.y-cy)/s+cy);}
V3 COL;
V3 SF;
V3 SS;
V1 SW;
V1 LD(V2 v0,V2 v1,V2 p)
{
V2 d=v1-v0;
return length(p-(v0+clamp(dot(d,p-v0)/dot(d,d),0.,1.)*d));
}
bool LD2(V1 x0,V1 y0,V1 x1,V1 y1,V2 p)
{
COL=SS;
return LD(V2(x0,y0),V2(x1,y1),p)<SW*.5;
}
float CD(V2 uv,V2 c)
{return distance(c,uv);}
bool CL(V2 uv,V1 x,V1 y,V1 r)
{
V2 c=V2(x,y);
V1 d=CD(uv,c);
COL=SS;
if(abs(d-r)<SW)RT
//COL=SF;
//if(d<r)RT
RF
}
float RD(V2 uv,V4 G,V1 R)
{
V1 cx = (G.x+G.z); 
V1 cy = (G.y+G.w); 
V1 dx = abs(uv.x - cx); 
V1 dy = abs(uv.y - cy); 
V1 px = G.z-R;
V1 py = G.w-R;
if( dx > px && dy > py ){return length(V2(dx-px,dy-py))-R;}
else if(dy-py/px*dx<0.){return dx-G.z;}
else{return dy-G.w;}
}
bool RECT(V2 uv,V1 l,V1 t,V1 w, V1 h, V1 R)
{
COL=SS;
if( abs(RD(uv,V4(l,t,w,h),R))<SW)RT
COL=SF;
if(RD(uv,V4(l,t,w,h),R)<0.0)RT
return false;
}
V1 area(V2 a,V2 b,V2 c){return(b.x-a.x)*(c.y-a.y)-(c.x-a.x)*(b.y-a.y);}
bool triangle(V2 a,V2 b,V2 c,V2 p)
{
V1 d=area(a,b,c);
if(d==0.)RF
V1 e=area(a,b,p);
if(d*e<0.)RF
e=area(b,c,p);
if(d*e<0.)RF
e=area(c,a,p);
if(d*e<0.)RF
RT
}
V2 pvsI[16];
#define SV(ax,ay,i)(pvsI[i].x=ax,pvsI[i].y=ay)
#define PVG(I) if(i==I)return pvsI[I];
V2 pvs(int i)
{
PVG(0)PVG(1)PVG(2)PVG(3)
PVG(4)PVG(5)PVG(6)PVG(7)
PVG(8)PVG(9)PVG(10)PVG(11)
PVG(12)PVG(13)PVG(14)PVG(15)
return V2(0,0);
}

bool POLY(V2 uv, const int nv)
{
COL=SS;
for(int i=0;i<16;++i)
{
if(i>nv-1)break;
if(LD(pvs(i),pvs(modi(i+1,nv)),uv)<SW*0.5)RT 
}
COL=SF;
for( int i=0;i<16;++i)
{
if(i>nv/2)break;
int n = i/2;
if(modi(i,2)==0)
{if( triangle(pvs(i),pvs(modi(i+1,nv)),pvs(modi(nv-n-1,nv)),uv) )RT;}
else
{if( triangle(pvs(modi(n+1,nv-1)),pvs(nv-n-1),pvs(nv-n-2),uv) )RT}
}
RF
}
#define CBI 10
bool CB(V2 uv,V1 p0x,V1 p0y,V1 p1x,V1 p1y,V1 p2x,V1 p2y,V1 p3x,V1 p3y)
{
if(uv.x+SW<min(min(min(p0x,p1x),p2x),p3x)||max(max(max(p0x,p1x),p2x),p3x)<uv.x-SW)RF
if(uv.y+SW<min(min(min(p0y,p1y),p2y),p3y)||max(max(max(p0y,p1y),p2y),p3y)<uv.y-SW)RF
V2 p0=V2(p0x,p0y);
V2 p1=V2(p1x,p1y);
V2 p2=V2(p2x,p2y);
V2 p3=V2(p3x,p3y);
COL=SS;
V2 pp9=p0;
for(int i=0;i<CBI;++i)
{
float t=V1(i+1)/V1(CBI);
V2 p5=mix(p1,p2,t);
V2 p9=mix(mix(mix(p0,p1,t),p5,t),mix(p5,mix(p2,p3,t),t),t);
if(LD(pp9,p9,uv)<SW*0.5)RT
pp9=p9;
}
RF
}
bool layer1(V2 uv)
{
SF=V3(0.4,1.,0.6);SS=V3(0.1,0.7,0.3);SW=9.1;
if(
CB(uv,6.9,126.6,5.9,111.2,115.4,11.1,115.4,11.1)||
CB(uv,115.4,11.1,115.4,11.1,133.6,-1.6,149.9,13.2)||
CB(uv,149.9,13.2,166.2,28.,151.9,46.3,151.9,46.3)||
LD2(151.9,46.3,102.2,98.6,uv)||
LD2(102.2,98.6,219.3,97.8,uv)||
CB(uv,219.3,97.8,219.3,97.8,247.7,97.2,249.1,126.9)||
CB(uv,249.1,126.9,250.5,156.5,221.2,157.4,221.2,157.4)||
LD2(221.2,157.4,96.9,156.3,uv)||
LD2(96.9,156.3,146.6,203.4,uv)||
CB(uv,146.6,203.4,146.6,203.4,163.6,223.3,148.5,240.7)||
CB(uv,148.5,240.7,133.5,258.1,107.9,243.7,107.9,243.7)||
CB(uv,107.9,243.7,107.9,243.7,7.8,142.,6.9,126.6)||
false
)RT
ELS{RF}
RF
}
void main( void )
{
V2 uvo = (gl_FragCoord.xy/resolution.xy);
uvo.y = 1.-uvo.y;
V2 uv = uvo*V2(256.,256.);
COL=V3(1,1,1);
gl_FragColor.a=1.;
IF(layer1(uv)){}
ELS{gl_FragColor.a=0.;COL=V3(1,1,1);}
gl_FragColor.xyz = COL;
}
