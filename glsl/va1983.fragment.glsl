/*
	pixel shader clock 2
	by psonice
*/
#ifdef GL_ES
precision mediump float;
#endif

#define pi 3.14159265358979
#define R(p,a) p=vec2(p.x*cos(a)+p.y*sin(a),p.y*cos(a)-p.x*sin(a));
#define smooth true

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = (( gl_FragCoord.xy / resolution.xy )-0.5);
	
	float l = length(position);
	
	float a = atan(position.y/position.x);
	a += position.x < 0. ? -pi * 0.5 : pi * 0.5;
	a*=-0.5;
	a+= pi;
 	//a /= -pi;
	//a = a*0.5+0.5;
	
	vec2 ts = vec2(0.,l);
	vec2 tm = ts, th = ts;
	
	ts = R(ts, (mod(time, 60.))/30.*pi);
	tm = R(tm, (mod(time, 60.*60.))/(30.*60.)*pi);
	th = R(th, (mod(time, 60.*60.*24.))/(30.*60.*24.)*pi);
	
	float s = length(position - ts) < 0.003 && (l < 0.4) ? 1. : 0.;
	float m = length(position - tm) < 0.007 && (l < 0.35) ? 1. : 0.;
	float h = length(position - th) < 0.01 && (l < 0.22) ? 1. : 0.;
	
 	a /= -pi;
	float c = (abs(mod(0.5+a * 12., 1.)-0.5) < 1./60. ? 1. : 0.) +
		(abs(mod(0.5 + a * 60., 1.)-0.5) < 1./120. ? 1. : 0.);
	c *= (l > 0.4) && (l < 0.5) ? 1. : 0.;
	c += l < 0.025 ? 1. : 0.;
	
	vec4 sec = vec4(1., 0., 0., 1.);
	vec4 minhour = vec4(.8);
	vec4 dial = vec4(0., 0., 0., 1.);
	vec4 bkg = vec4(0.4);

	gl_FragColor = c > 0.5 ? dial : (m + h > 0.5 ? minhour : (s > 0.5 ? sec : bkg));
//		vec4( s + m + h + c);

}