#define PROCESSING_COLOR_SHADER
#ifdef GL_ES
precision mediump float;
#endif

//swinging sixties? groovy baby!
//flowers time?
uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;                                                                         
vec2 conj(vec2 v){return vec2(v.x,-v.y);}
vec2 inv(vec2 v){return conj(v)/dot(v,v);}
vec2 mu(vec2 u,vec2 v){return vec2( dot(u,conj(v)),dot(u,v.yx));}
vec2 fonc(vec2 p){return inv(p-0.9*sin(time))*(2.0+cos(time))+ inv(p+0.5*cos(time))*(2.0+sin(time));}


void main(void)
{    
 vec2 p =4.0 *( gl_FragCoord.xy / resolution.xy)- 2.0 ;
 	p.x*=resolution.x/resolution.y;
	vec2 r = p;

 	for(int i=0;i<32;i++) {
		if (length(p) >= 5.0)
		break;
		p = r + (fonc(mu(p,p)));
	}
	p=exp(abs(p/5.0));
 	gl_FragColor =vec4(cos(0.7*sin(p.x)),abs(sin(1./(p.y-p.x))),cos(dot(p,p)/10.),1.);

}