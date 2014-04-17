#ifdef GL_ES
precision mediump float;
#endif
uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;    
varying vec2 surfacePosition;
vec2 conj(vec2 v){return vec2(v.x,-v.y);}
vec2 inv(vec2 v){return conj(v)/dot(v,v);}
vec2 mu(vec2 u,vec2 v){return vec2( u.x*v.x-u.y*v.y,u.x*v.y+u.y*v.x);}
vec2 fonc(vec2 p,vec2 t){return inv(p-0.9*sin(t))*(2.0+cos(t))+ inv(p+0.5*cos(t))*(2.0+sin(t));}
const float a=0.78;
const float b=1.14;

float f(vec2 p)
{
	vec2 j = p;
	p = vec2(0);
	//float tempo=atan(mouse.y, mouse.x);//(sin(time*0.1+1.57)+1.0)*(b-a)/2.0+a;	
 	for(int i=0;i<40;i++){
 	 //p=fonc(mu(mu(p,p),inv(p-0.5)),tempo+mouse);
	 p=inv(vec2(p.x*p.x - p.y*p.y, 2.0*p.x*p.y) + j);
		//p = abs(p - 1.0);
	}
	float s = length(sin(p));
	float c = step(s, 1.0);
	return c;
}

vec2 grad( in vec2 p )
{
    vec2 h = vec2( 0.001, 0.0 );
    return vec2( f(p+h.xy) - f(p-h.xy),
                 f(p+h.yx) - f(p-h.yx) )/(2.0*h.x);
}
float color( in vec2 x )
{
    float v = f( x );
    vec2 g = grad( x );
    float de = abs(v)/length(g);
    return smoothstep( 0.19, 0.20, de );
}
void main(void)
{    
 vec2 p = surfacePosition;
 	p*=3.0;

	gl_FragColor = vec4(color(p));

}