
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;
vec2 conj(vec2 v){return vec2(v.x,-v.y);}
vec2 inv(vec2 v){return conj(v)/dot(v,v);}
vec2 mu(vec2 u,vec2 v){return vec2( u.x*v.x-u.y*v.y,u.x*v.y+u.y*v.x);}
vec2 fonc(vec2 p,float t){return mu(inv(mu(p+sin(t),p+sin(t))),p);}

const float a=0.1;
const float b=0.628;
void main(void)
{    
 vec2 p = 2.0 *( gl_FragCoord.xy / resolution.xy)- 1.0 ;
 	p.x*=resolution.x/resolution.y;
 	//float tempo=time*0.01;
 	float tempo=((cos(time*0.3)*0.0314+0.0314)*(b-a)/0.0628+a);	
 	for(int i=0;i<10;i++){
 	 p=0.3*(cos(tempo)+2.0)*(fonc(p,tempo));}
 	gl_FragColor =vec4(p.x+p.y,p.y+p.x,10.0*p.x*p.y,1.);
}