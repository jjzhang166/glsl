#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;



vec2 conj(vec2 v){return vec2(v.x,-v.y);}
vec2 inv(vec2 v){return conj(v)/dot(v,v);}
vec2 rot(vec2 v,float a){return vec2(v.x*cos(a)-v.y*sin(a),v.x*sin(a)+v.y*cos(a));}
vec2 mu(vec2 u,vec2 v){return vec2( u.x*v.x-u.y*v.y,u.x*v.y+u.y*v.x);}

vec2 fractal(vec2 p,vec2 c){ return mu(p, p)+c;}

const float a=4.0;
const float b=4.2;
void main( void ) {
	vec2 p =2.0*( gl_FragCoord.xy / resolution.xy ) -1.0;
	float tempo=(sin(time*0.3-1.57)+1.0)*(b-a)/2.0+a;		
   	vec2 cc=vec2(-0.707+0.1*cos(tempo)+0.1*mouse.y,0.25 +0.1*sin(tempo)+0.1*mouse.x);		
	for(int i = 0; i < 80; i++){
	 	p=fractal(p,cc);
        }
	gl_FragColor =vec4((abs(p.y)*abs(p.x)),length(p),1.0-length(p),1.);
}