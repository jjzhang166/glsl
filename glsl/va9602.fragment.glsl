
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;
vec2 conj(vec2 v){return vec2(v.x,-v.y);}
vec2 inv(vec2 v){return conj(v)/dot(v,v);}
vec2 mu(vec2 u,vec2 v){return vec2( u.x*v.x-u.y*v.y,u.x*v.y+u.y*v.x);}
vec2 fonc(vec2 p,float t){return inv(p+0.99*sin(t*0.9))* inv(p+0.99*cos(t*0.9));}

const float a=3.0;
const float b=4.0;
void main(void)
{    
 vec2 p = 4.0 *( gl_FragCoord.xy / resolution.xy)- 2.0 ;
 	p.x*=resolution.x/resolution.y;
 	float tempo=((cos(time*0.03)*0.0314+0.0314)*(b-a)/0.0628+a);	
 	for(int i=0;i<10;i++){
 	 p=0.2*(fonc(p,tempo));}
 	gl_FragColor =vec4(5.0*p.x*p.y,p.y+p.x,10.0*p.x*p.y,1.);
}
