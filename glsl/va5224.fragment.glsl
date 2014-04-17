//MG
#ifdef GL_ES
precision mediump float;
#endif
#define PI 3.1415926535897932384626433832795

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main() {
	vec2 p=(gl_FragCoord.xy/resolution.y)*80.0;
	p.x-=resolution.x/resolution.y*40.0;p.y-=40.0;
	float dist,fx,angle,tme=-mod(time*10.0,2.0*PI);
	mat2 m=mat2(cos(tme)-0.05,-sin(tme)+0.05,
		    sin(tme)-0.05,cos(tme)+0.05);
	p=m*p;
	
	for (float i=0.0;i<=100.0;i+=1.0) {
		dist=sqrt(p.x*p.x+p.y*p.y);
		
		angle=acos(p.x/dist);
		if (p.y<0.0) {angle=2.0*PI-angle;}
		angle=angle+2.0*PI*(i-1.0);
		
		fx=1.5/abs(angle-dist);
		
		if (fx>1.0) {fx=1.0;}
		else {fx=0.0;}
		fx/=4.0;
		
		gl_FragColor+=vec4(fx*4.0,fx*2.0,fx,1.0);
	}
}