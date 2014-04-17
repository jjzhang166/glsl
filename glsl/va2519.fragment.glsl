#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer; 
void main( void ) {

	vec2 p = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
	vec2 pos = p * 11.0 * cos(sin(time/5.0));
	pos.y/=resolution.x/resolution.y;
	float v = (sin(pos.x) * cos(pos.y)) *1.0 + time;
	float a = mod(v - fract(v), 1.3);
	a=.5+a*.1;
	gl_FragColor = .7*vec4(a, a+.2*p.y, a+.5*p.y, 1.0 );
	gl_FragColor.r+=.4*texture2D(backbuffer,(abs(.3*sin(time*1.1)*cos(time*1.1))+gl_FragCoord.xy/resolution));
	gl_FragColor.g+=.4*texture2D(backbuffer,(abs(.3*sin(time)*cos(time))+gl_FragCoord.xy/resolution));
	gl_FragColor.b+=.4*texture2D(backbuffer,(abs(.3*sin(time*.9)*cos(time*.9))+gl_FragCoord.xy/resolution));
	
	
}