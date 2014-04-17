#ifdef GL_ES
precision mediump float;
#endif
// Just playing around with atan, by Hjalmar Snoep
#define PI 3.14159265359
uniform float time;
//uniform vec2 mouse;
uniform vec2 resolution;

void main (void) {
	vec2 p=gl_FragCoord.xy;
	float x=(p.x-resolution.x/2.)/1.;
	float y=(p.y-resolution.y/2.)/1.;
	float r=sqrt(x*x+y*y);
	r=pow(r,0.5);
	float u=atan(x,y);
	float v=atan(y,x);
	float ruv=sqrt(u*u+v*v);
	float a=cos(time+r+9.0*u)+sin(-time+r-7.0*ruv);
	if(a<0.5) a=0.0;
	else if(a>1.56) a=3.0;
	x=x+sin(r*a*v)*5.0;
	y=y+cos(r*a*u)*5.0;
	r=sin(sqrt(x*x+y*y)/3.0);
	if(r<.9) a=0.0;
	gl_FragColor=vec4(sin(a),sin(a/2.0),sin(a),1.0);
}