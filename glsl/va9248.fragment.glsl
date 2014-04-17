#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265359
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main (void) {
	vec2 p = (gl_FragCoord.xy - (resolution.xy/vec2(2.)))/vec2(60.);
	float r=1./length(p)+time;
	float a=atan(p.x,p.y)/PI/2.+sin(time+cos(time+r)+r)/6.+sqrt(sin(r));
	r=r+mod(a,.1);
	float V = abs(mod(a,.1)) < .01 || abs(mod(r,1.)) < .5 ? length(vec2(p.x*sin(r),p.y*cos(r))) : 0.5;
	gl_FragColor=vec4(tan(r*V)*V, cos(r*V)*V, sin(r*V)*V, 1.);
}