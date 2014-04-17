#ifdef GL_ES
precision mediump float;
#endif
//idea by harley for my intro... need some text writer on top ;)
#define PI 3.14159265359
uniform float time;
//uniform vec2 mouse;
uniform vec2 resolution;

void main (void) {
	vec2 p=gl_FragCoord.xy;
	float x=(p.x-resolution.x/2.)/60.;
	float y=(p.y-resolution.y/2.)/60.;
	float r=1./sqrt(x*x+y*y)+cos(time);
	float a=atan(x,y)/PI/2.+atan(time)/6.+sqrt(cos(r));
	r=r+mod(a,.1);
	float V=abs(mod(a,.1))<.01||abs(mod(r,1.))<.1?1.:0.;
	gl_FragColor=vec4(V*max(sin(time),cos(time+r)),V*cos(time+x)*x,V*sin(time+y)*y,1.);
}