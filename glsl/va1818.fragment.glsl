#ifdef GL_ES
precision mediump float;
#endif

// An attempt to simulate a nice chemical reaction I saw somewhere... - kabuto

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

void main( void ) {
	vec2 dpos = sin(gl_FragCoord.xy/resolution.xy*6.283)*.5+.5;
	vec4 cPrev = (texture2D(backbuffer, gl_FragCoord.xy / resolution) * 2.
		+ texture2D(backbuffer, fract((gl_FragCoord.xy + vec2( 1,0)) / resolution))*dpos.y
		+ texture2D(backbuffer, fract((gl_FragCoord.xy + vec2(-1,0)) / resolution))*(1.000001-dpos.y)
		+ texture2D(backbuffer, fract((gl_FragCoord.xy + vec2(0, 1)) / resolution))*(1.000001-dpos.x)
		+ texture2D(backbuffer, fract((gl_FragCoord.xy + vec2(0,-1)) / resolution))*dpos.x
	)*.25-.5;
	
	float rnd = fract(fract(time*2.15461234)*fract(time*6.634512)*fract(gl_FragCoord.x*4.17673+2.1454)*fract(gl_FragCoord.y*3.72435+.1672)*10000.);

	float l = length(cPrev.xz);
	l = min(l*1.01,.5);
	float a = atan(cPrev.x,-cPrev.z)+0.5*mouse.x;
	a = cPrev.w < .5 ? fract(gl_FragCoord.y*mouse.y)*6. : min(a, a*a*768.11);
	
	cPrev = vec4(sin(a)*l+.5,sin(a-1.)*l+.5,-cos(a)*l+.5,1);

	gl_FragColor = cPrev;
}