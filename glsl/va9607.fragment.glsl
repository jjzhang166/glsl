#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;
vec2 conj(vec2 v){return vec2(v.x,-v.y);}
vec2 inv(vec2 v){return conj(v)/dot(v,v);}
vec2 mu(vec2 u,vec2 v){return vec2( u.x*v.x-u.y*v.y,u.x*v.y+u.y*v.x);}
vec2 fonc(vec2 p,float t){return inv(p+sin(t)) - inv(p+3.*cos(t));}

const float a=2.2;
const float b=2.7;
void main(void)
{    
 vec2 p = 4.0 *( gl_FragCoord.xy / resolution.xy)- 2.0 ;
 	p.x*=resolution.x/resolution.y;
 	float tempo=(sin(time*0.1-1.57)+1.0)*(b-a)/2.0+a;
//float tempo=time*0.1;	
 	for(int i=0;i<10;i++){
 	 p=(fonc(mu(p,p),tempo));}
 	 p=clamp(p,0.1,1.);
 	gl_FragColor =vec4(abs(sin(p.x*p.y)),abs(sin(1.0/(p.y*p.y))),1.0-exp(-p.x*p.y),1.);
}