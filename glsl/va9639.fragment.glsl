#ifdef GL_ES
precision mediump float;
#endif

//swinging sixties? groovy baby!
uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;                                                                         
vec2 conj(vec2 v){return vec2(v.x,-v.y);}
vec2 inv(vec2 v){return conj(v)/dot(v,v);}
vec2 mu(vec2 u,vec2 v){return vec2( dot(u,conj(v)),dot(u,v.yx));}
vec2 fonc(vec2 p,float t){return inv(p-0.9*sin(t))*(2.0+cos(t))+ inv(p+0.5*cos(t))*(2.0+sin(t));}

const float a=5.0;
const float b=2.28;
void main(void)
{    
 vec2 p =16.0 *( gl_FragCoord.xy / resolution.xy)- 8.0 ;
 	p.x*=resolution.x/resolution.y;
	p /=18.0;
	vec2 r = p;
	p = vec2(0.99/(1.5+sin(time+length(p))), atan(p.x,p.y));
 	float tempo=(sin(time*0.1-1.57)+1.0)*(b-a)/2.0+a;	
 	for(int i=0;i<32;i++) {
		if (length(p) >= 5.0)
			break;
		p = r + (fonc(mu(p,p),tempo));
	}
	p = vec2(p.x * cos(p.y), p.x * sin(p.y));
 	gl_FragColor =vec4(2.0*cos(0.7*sin(p.x)),abs(sin(1./(p.y-p.x))),1.0-exp(-p.y*p.x),1.);
}