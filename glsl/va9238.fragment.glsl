#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265359
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main (void) {
	vec2 p=gl_FragCoord.xy;
	float x=(p.x-resolution.x/2.)/10.*sin(time);
	float y=(p.y-resolution.y/2.)/10.*sin(time);
	float r=sqrt(x*x+y*y);
	float a=atan(x,y)/PI/4.;
	float v=r+a*tan(time)*1.;
	float V=mod(v,1.);
	gl_FragColor=vec4(V+sin(time),(V+cos(time))/4.+.75,1.-V+cos(time),1.);
}