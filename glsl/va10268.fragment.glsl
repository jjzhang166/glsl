#ifdef GL_ES
precision mediump float;
#endif
// Alien Hyve Queen, by Hjalmar Snoep
#define PI 3.14159265359
uniform float time;
//uniform vec2 mouse;
uniform vec2 resolution;

void main (void) {
	vec2 p=gl_FragCoord.xy;
	float zoom=2.2+2.0*sin(time/3.0);
	float x=(p.x-resolution.x/2.)*zoom;
	float y=(p.y-resolution.y/2.)*zoom;
	float rxy=sqrt(x*x+y*y);
	float u=atan(x,y)*3.0;
	float rxu=sqrt(x*x+u*u*2600.0*cos(time/1.8));
	float ryu=sqrt(y*y+u*u*2500.0*sin(time/1.9));
	float red=sin((rxu-ryu)/7.0);
	float green=sin((rxu+ryu)/13.0);
	float blue=sin((ryu*rxu)/1700.0);
	
	if(red+green+blue<2.2)
	{
		red=0.0;
		green=blue*0.5;
		blue=blue*0.1;
	}
	float dist=pow(rxy,0.15);
	red=red/dist;
	green=green/dist;
	blue=blue/dist;
	
	gl_FragColor=vec4(red,green,blue,1.0);
}