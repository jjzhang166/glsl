#ifdef GL_ES
precision mediump float;
#endif

// This seems much more managable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

void main( void ) {
	vec4 cPrev = (texture2D(backbuffer, gl_FragCoord.xy / resolution) * 4.
		+ texture2D(backbuffer, (gl_FragCoord.xy + vec2( 1,0)) / resolution)
		+ texture2D(backbuffer, (gl_FragCoord.xy + vec2(-1,0)) / resolution)
		+ texture2D(backbuffer, (gl_FragCoord.xy + vec2(0, 1)) / resolution)
		+ texture2D(backbuffer, (gl_FragCoord.xy + vec2(0,-1)) / resolution))*.125-.5;
	
	float rnd = 0.01;
	vec2 m = mouse-gl_FragCoord.xy/resolution;
	float l = length(cPrev.xz);
	l = min(l*1.01,.5);
	float a = atan(cPrev.x,-cPrev.z)+rnd;
	a = cPrev.w < 0.2 ? -max(fract(dot(m,m)*4.)-.5,0.)*12.*min(max(abs(m.x*10000.-2.),0.),1.) : dot(m,m) < .0001 ? 1. :  min(a, a*a*8.);
	
	cPrev = vec4(sin(a)*l+.5,sin(a-1.0)*l+.5,-cos(a)*l+.5,1)*0.999;

	gl_FragColor = cPrev;
}