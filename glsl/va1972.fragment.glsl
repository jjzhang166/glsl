#ifdef GL_ES
precision mediump float;
#endif

// An attempt to simulate a nice chemical reaction I saw somewhere... - kabuto

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

void main( void ) {
	vec4 cPrev = (texture2D(backbuffer, gl_FragCoord.xy / resolution) * 4.
		+ texture2D(backbuffer, (gl_FragCoord.xy + vec2( 1,0)) / resolution)
		+ texture2D(backbuffer, (gl_FragCoord.xy + vec2(-1,0)) / resolution)
		+ texture2D(backbuffer, (gl_FragCoord.xy + vec2(0, 1)) / resolution)
		+ texture2D(backbuffer, (gl_FragCoord.xy + vec2(0,1)) / resolution))*.125-.5;
	
	float rnd = fract(fract(time*2.15461234)*fract(time*6.634512)*fract(gl_FragCoord.x*.17673+2.1454)*fract(gl_FragCoord.y*.72435+.1672)*10000.);

	vec2 m = mouse-gl_FragCoord.xy/resolution;
	float l = length(cPrev.xz);
	l = min(l*1.01,.1);
	float a = atan(cPrev.x,-cPrev.z)+rnd*.05;
	a = cPrev.w < .5 ? -max(fract(dot(m,m)*4.)-.5,0.)*12.*min(max(abs(m.x*10.-2.),0.),1.) : dot(m,m) < .0001 ? 1. :  min(a, a*a*8.);
	
	cPrev = vec4(sin(a)*l+.5,sin(a-1.)*l+.5,-cos(a)*l+.5,1);

	gl_FragColor = cPrev;
}