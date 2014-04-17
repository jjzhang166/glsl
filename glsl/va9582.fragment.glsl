#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;
vec2 conj(vec2 v){return vec2(v.x,-v.y);}
vec2 inv(vec2 v){return conj(v)/dot(v,v);}
vec2 mu(vec2 u,vec2 v){return vec2( u.x*v.x-u.y*v.y,u.x*v.y+u.y*v.x);}
vec2 fonc(vec2 p){return mu(p,inv(mu(p,p)*2.+cos(time*0.1)));}
void main(void)
{    
 vec2 p = 2.0 *( gl_FragCoord.xy / resolution.xy)- 1.0 ;
 	p.x*=resolution.x/resolution.y;
 	vec2 col=p;
 	for(int i=0;i<10;i++){
 	 col=fonc(col);}
 	vec2 col1=normalize(vec2(col.x*cos(-time)-col.y*sin(-time),col.x*sin(-time)+col.y*cos(-time)));
 	gl_FragColor =vec4(col.x+col1.y,col.y+col1.x,col1.x*col1.y,1.);
 }