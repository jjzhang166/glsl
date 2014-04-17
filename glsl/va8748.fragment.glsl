// prisme vrille :Thematica en etude
#ifdef GL_ES
precision mediump float;
#endif


uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;




float pToCylindre(vec3 p, float r, float h){
	vec3 pa=abs(p);
	float d0=pa.y-h;
	float d1=length(p.xz)-r;
	return d1+step(h,pa.y)*d0;

}


float pToqqPrism( vec3 p,float a,float base,float h)
{
    vec3 pa = abs(p);
    float d= sin(a)*(pa.x-base)+cos(a)*p.z;
 if(p.z<=0.0)  d=max(pa.z,d) ;
 return max(d, p.y-h);
}

vec3 rotZ(vec3 v, float a){
float c=cos(a+time);
float s=sin(a+time);
mat3 m=mat3(c,-s,0.0,s,c,0.0,0.0,0.0,1.0);
return v*m;
}

vec3 rotY(vec3 v, float a){
float c=cos(a);
float s=sin(a);
mat3 m=mat3(c,0.0,-s,0.0,0.1,.0,s,0.0,c);
return v*m;
}
mat3 rot(vec3 axe, float angle)
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

void main(){
vec2 position=2.0*(gl_FragCoord.xy/resolution.xy)-1.0;

                                         //perspective conique
vec3 oeil=vec3(0.0,0.0,-3.0);
mat3 matrice=rot(normalize(vec3(1.0,1.0,1.0)), time);
vec3 pos=vec3(position.x,position.y,-0.7);      
vec3 dirRayon=normalize(matrice*(pos-oeil));
vec3 posRayon=matrice*pos;

                                        //sphere marching
float lambda=0.0;
float lamb=0.0;
float nbpas=0.0;
for(int i=0;i<100;i++){
nbpas=nbpas+0.01;
	lamb=pToqqPrism(rotY(posRayon,posRayon.y), 1.0, 0.6,0.6);
	lambda+=lamb;
	posRayon=posRayon+lamb*dirRayon;
	if(lamb<1.0e-7) break;
}
gl_FragColor=vec4((1.0-nbpas)*(1.0-nbpas),nbpas/10.0,nbpas/10.0,1.0);
}
