
//swinging sixties? groovy baby!
//flowers time?
//time flower and black flower!
//sphere flowers

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;                                                                         
vec2 conj(vec2 v){return vec2(v.x,-v.y);}
vec2 inv(vec2 v){return conj(v)/dot(v,v);}
vec2 mu(vec2 u,vec2 v){return vec2( dot(u,conj(v)),dot(u,v.yx));}
vec2 sim(float t,float k){return k*vec2(cos(t*time),sin(t*time));}
vec2 fonc(vec2 p){return mu(inv(p-.09*sin(time))+ inv(p+.09*cos(time)),sim(1.,time)*inv(mu(p,p)));}

void main(void)
{    
 vec2 p =4.0 *( gl_FragCoord.xy / resolution.xy)- 2.0 ;
 	p.x*=resolution.x/resolution.y;
	vec2 r = p;
 	for(int i=0;i<64;i++) {
		if (length(p) >= 5.0)
		break;
		p = r + (fonc(mu(p,p)));
	}
	p=exp(abs(p/5.0));
 	gl_FragColor =vec4(cos(1.5*sin(p.x)),1.-abs(sin(1./(p.y-p.x))),1.-cos(dot(p,p)/10.),1.);
}