/*
	pixel shader clock
	by psonice
*/
#ifdef GL_ES
precision mediump float;
#endif

#define pi 3.14159265358979

#define smooth true

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
//test
void main( void ) {

	vec2 position = (( gl_FragCoord.xy / resolution.xy )-0.5);
	
	float l = length(position);
	
	float a = atan(position.y/position.x);
	a += position.x < 0. ? -pi * 0.5 : pi * 0.5;
 	a /= -pi;
	a = a*0.5+0.5;
	
	float ts, tm, th;
	if(smooth){
		ts = (mod(time, 10.))/10.;
		tm = (mod(time, 60.*60.)/60.)/60.;
		th = (mod(time, 60. * 60. * 24.)/(60. * 60.))/24.;
	}{
		ts = floor(mod(time, 60.))/60.;
		tm = floor(mod(time, 60.*60.)/60.)/60.;
		th = floor(mod(time, 60. * 60. * 24.)/(60. * 60.))/24.;
	}
	
	float s = (abs(ts-a) < 1./480.) && (l < 0.4) ? 1. : 0.;
	float m = (abs(tm-a) < 1./240.) && (l < 0.35) ? 1. : 0.;
	float h = (abs(th-a) < 1./120.) && (l < 0.3) ? 1. : 0.;
	
	float c = (abs(mod(0.5+a * 12., 1.)-0.5) < 1./60. ? 1. : 0.) +
		(abs(mod(0.5 + a * 60., 1.)-0.5) < 1./120. ? 1. : 0.);
	c *= (l > 0.4) && (l < 0.5) ? 1. : 0.;
	c += l < 0.025 ? 1. : 0.;

	gl_FragColor = vec4( s, m, h, 1. ) + c;

}