#ifdef GL_ES
precision mediump float;
#endif
// Thematica
#define PI 3.14159265
#define a 0.18
uniform float time;
uniform vec2 resolution;

void main (void) {
	float t=time*0.5;
	float scal=4.0+2.0*sin(time*0.4);
	vec2 p=(2.0*(gl_FragCoord.xy/resolution.xy)-1.0)*scal;
	p=vec2(p.x*cos(t)-p.y*sin(t),p.x*sin(t)+p.y*cos(t));
	float d=length(p);
	float theta0=((p.y<0.0)? 2.0*PI - acos(p.x/d) : acos(p.x/d))*4.0;
	float d0=d-a*theta0;
	float n=floor(d0/(2.0*PI*a));
	float r=d-2.0*a*PI*n;
	float col1=0.5*abs(r-theta0*a)/(a*scal);
	float col2=1.0-0.5*abs(r-theta0*a*0.5)/(a*scal*0.5);
	float col3=1.0-0.5*abs(r-theta0*a*0.2)/(a*scal*0.2);
	gl_FragColor=vec4(col1,col2,col3,1.0);
	}