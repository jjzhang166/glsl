#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 p = gl_FragCoord.xy / resolution.x - vec2(0.5, 0.5/(resolution.x/resolution.y));
	//p *= resolution.x/resolution.y;
	float l = length(p);
	l = pow(l, 0.5)*10.;
	
	float o = mod(l-time*sin(time), 1.) > 0.5 ? 1. : 0.;
	o += mod(l+time*sin(time), 1.) > 0.5 ? 1. : 0.;
	o = mod(o, 2.);
	gl_FragColor = vec4(o * vec4(cos(time)*.5+.5, sin(time)*.5+.5, sin(time)*.5+.5, 1.));
}