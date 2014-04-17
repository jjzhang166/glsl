
#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;
vec2 conj(vec2 v){return vec2(v.x,-v.y);}
vec2 inv(vec2 v){return conj(v)/dot(v,v);}
vec2 mu(vec2 u,vec2 v){return vec2( u.x*v.x-u.y*v.y,u.x*v.y+u.y*v.x);}
vec2 fonc(vec2 p){return mu((mu(p,p)-2.8*sin(time*0.4)),inv(mu(p,p)+1.1*sin(time*0.6)));}
void main(void)
{    
 vec2 p = 2.0 *( gl_FragCoord.xy / resolution.xy)- 1.0 ;
 p.x*=resolution.x/resolution.y;
// p=mod(abs(p),vec2(1.,1.))-0.5;//repetition
// p=vec2(p.x*cos(time)-p.y*sin(time),p.x*sin(time)+p.y*cos(time));//rotation
 vec2 col=fonc(fonc(fonc(p)));
vec2 icol=inv(col);
gl_FragColor =vec4(col.x+icol.y,col.y+icol.x,icol.x+icol.y,1.);
 }
