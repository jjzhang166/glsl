#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;
vec2 conj(vec2 v){return vec2(v.x,-v.y);}
vec2 inv(vec2 v){return conj(v)/dot(v,v);}
vec2 mu(vec2 u,vec2 v){return vec2( u.x*v.x-u.y*v.y,u.x*v.y+u.y*v.x);}
vec2 fonc(vec2 p,float t){return mu(mu(p,p),inv(mu(p,p)+cos(t*0.228)));}

const float a=5.0;
const float b=5.8;
void main(void)
{    
 vec2 p = 4.0 *( gl_FragCoord.xy / resolution.xy)- 2.0 ;
 	vec2 col=p;
	
 	float temps=(cos(time)*3.14+3.14)*(b-a)/6.28+a;	
 	for(int i=0;i<20;i++){
 	 col=fonc(col,temps);}
 	gl_FragColor =vec4(col.x+col.y,col.y+col.x,10.0*col.x*col.y,1.);
 }
