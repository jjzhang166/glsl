#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265359
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main (void) {
	vec2 p=gl_FragCoord.xy;
	float x=(p.x-resolution.x/2.)/60.;
	float y=(p.y-resolution.y/2.)/60.;
	float r=1./sqrt(x*x+y*y)+time;
	float a=atan(x,y)/PI/2.+sin(time)/6.+sqrt(sin(r));
	r=r+mod(a,.1);
	float V=abs(mod(a,.1))<.01||abs(mod(r,1.))<.1?1.:0.;
	gl_FragColor=vec4(0.,V,0.,1.);
}