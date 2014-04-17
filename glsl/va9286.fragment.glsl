#ifdef GL_ES
precision mediump float;
#endif

// Thematica le 10 juin 2013 : Interpolation

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float pi=3.1415926;
float sdCyl(vec3 p, float h,float r){
vec3 pa=abs(p);
float ra=length(pa.xz);
float k=(r<ra)? length(vec2(ra-r,pa.y-h)) : pa.y-h-0.001;
 return (pa.y<h)?(ra-r) : k;
}



float pointToBoxVide( vec3 p, vec3 b, float r )
	{	vec3 pa=abs(p);
		float dy= length( vec3( b.x-pa.x  ,  b.z-pa.z,  (-b.y+pa.y)*step(b.y,pa.y) ))-r;
		float dx= length( vec3( b.y-pa.y  ,  b.z-pa.z,  (-b.x+pa.x)*step(b.x,pa.x) ))-r;
		float dz= length( vec3 (b.x-pa.x  ,  b.y-pa.y,  (-b.z+pa.z)*step(b.z,pa.z) ))-r;
		return min(dx,min(dy,dz));
	}
	
vec3 rotX(vec3 v, float a){
float c=cos(a);
float s=sin(a);
mat3 m=mat3(1.0,0.,0., 0.,c,-s,0.,s,c);
return v*m;
}	
	
vec3 rotZ(vec3 v, float a){
float c=cos(a);
float s=sin(a);
mat3 m=mat3(c,-s,0.0,s,c,0.0,0.0,0.0,1.0);
return v*m;
}

vec3 rotY(vec3 v, float a){
float c=cos(a);
float s=sin(a);
mat3 m=mat3(c,0.,-s,  0.,1.0,.0, s,0.,c);
return v*m;
}
mat3 rot(in vec3 axe, in float angle)
{ 
    float s = sin(angle);
    float c = cos(angle);
    float d = 1.0 - c;
    axe = normalize(axe);
    float x=axe.x;
    float y=axe.y;
    float z=axe.z; 
    return  mat3(
   	d * x * x + c      , d * x * y - z * s ,  d * z * x + y * s,
               d * x * y + z * s,  d * y * y + c     ,  d * y * z - x * s,
               d * z * x - y * s ,  d * y * z + x * s,  d * z * z + c      );         
}
vec3 rotate(vec3 v,vec3 axe,float a){
mat3 m=rot(axe,a);
return m*v;
}
vec4 min4(vec4 u,vec4 v){
return (u.x<v.x)? u : v;
}


void main(){
vec2 position=2.0*(gl_FragCoord.xy/resolution.xy)-1.0;
position.x*=resolution.x/resolution.y;                             
vec2 angl=vec2( ( -mouse.x+0.5)*pi,  (-0.5+mouse.y)*pi) ;                                  
vec3 oeil=vec3(0.0,0.0,-5.5);
float focale=3.0;    
vec3 dirRayon=normalize(rotY(rotX(vec3(position.x,position.y,focale),angl.y),angl.x));
vec3 posRayon0=rotY(rotX(oeil,angl.y),angl.x);

                                        //sphere marching
float lambda=0.0;
vec4 lamb=vec4(0.0);
vec3 col=vec3(0.,0.,0.);
vec3 axDepart=normalize(vec3(1.,0.,1.));
vec3 axArrivee=normalize(vec3(-1.,0.,1.));
vec3 axFinal=normalize(cross(axDepart,axArrivee));
vec3 posDepart=vec3(0.,1.,0.);
vec3 posArrivee=vec3(0.,-1.,0.);
float angle=acos(dot(axDepart,axArrivee));
float angleDep = acos(dot(vec3(0.,1.,0.),axDepart));
vec3 axRotDep = cross(vec3(0.,1.,0.),axDepart);
float temp=mod(time,10.)/10.0;



float pair=floor(mod(time/10.0,2.0));
if(pair<0.5)temp=1.0-temp;
vec3 axetemp=mix(axDepart,axFinal,temp);
vec3 posRayon=rotY(rotX(oeil,angl.y),angl.x);
mat3 matrixR= rot(axRotDep,-angleDep)*rot(axFinal,-angle*temp);
for(int i=0;i<50;i++)
{
	
	vec3 centre=mix(posDepart,posArrivee,temp);
	vec4 lamb0=vec4(sdCyl(matrixR*(posRayon-centre), 1.4143,0.2),1.,1.,0.);
	vec4 lamb1=vec4(pointToBoxVide(posRayon,vec3(1.,1.,1.),0.03),0.,0.,1.0);
	lamb=min4(lamb0,lamb1);
	lambda+=lamb.x;
	posRayon=posRayon+lamb.x*dirRayon;	
	if(lamb.x<1.0e-4 ) {break;}
	
}
vec3 prn=normalize(posRayon);
col=(lamb.x<1.e-4)? col=dot(lamb.yzw,prn)*prn : prn;
gl_FragColor=vec4(col,1.0);
}
