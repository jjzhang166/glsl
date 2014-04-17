// le coq

#define PROCESSING_COLOR_SHADER

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;                                                                         
vec2 conj(vec2 v){return vec2(v.x,-v.y);}
vec2 inv(vec2 v){return conj(v)/dot(v,v);}
vec2 mu(vec2 u,vec2 v){return vec2( u.x*v.x-u.y*v.y,u.x*v.y+u.y*v.x);}

vec2 fonc(vec2 p,float t){return (inv(p-1.5*sin(t))* inv(p+1.5*sin(t)));}

const float a=3.6;
const float b=3.7;
void main(void)
{    
 vec2 p =2.8 *( gl_FragCoord.xy / resolution.xy)- 1.4 ;
 	p.x*=resolution.x/resolution.y;	
 	float tempo=(sin(time*0.1-1.57)+1.0)*(b-a)/2.0+a;	
 	for(int i=0;i<5;i++){
 	 p=(fonc(mu(p,p),tempo));}
 	gl_FragColor =vec4(cos(1.5*sin(p.x)),1.-abs(sin(1./(p.y-p.x))),1.-cos(dot(p,p)/5.),1.);
}