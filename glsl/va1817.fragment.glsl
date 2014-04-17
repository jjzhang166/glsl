#ifdef GL_ES
precision mediump float;
#endif

// 

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

void main( void ) {
	vec2 dpos = sin(gl_FragCoord.xy/resolution.xy*6.283)*.5+.5;
	vec4 cPrev = (texture2D(backbuffer, gl_FragCoord.xy / resolution) * 2.
		+ texture2D(backbuffer, fract((gl_FragCoord.xy + vec2( 1,0)) / resolution))*(dpos.y)
		+ texture2D(backbuffer, fract((gl_FragCoord.xy + vec2(-1,0)) / resolution))*(1.001-dpos.y)
		+ texture2D(backbuffer, fract((gl_FragCoord.xy + vec2(0, 1)) / resolution))*(1.001-dpos.x)
		+ texture2D(backbuffer, fract((gl_FragCoord.xy + vec2(0,-1)) / resolution))*(dpos.x)
	)*.25-.5;
	
	float rnd = fract(fract(mouse.x*0.001)*fract(mouse.y*0.1)*fract(gl_FragCoord.x*.13+54.)*fract(gl_FragCoord.y*.1+6.1672)*100.);

	float l = length(cPrev.xz);
	l = min(l*1.5,0.5);
//	float a = atan(cPrev.x,-cPrev.x)+rnd*.05;
	float a = atan(cPrev.x,cPrev.z)+rnd*0.005;
	a = cPrev.w < .005 ? fract(gl_FragCoord.y*.07)*6. : min(a, a*a*20.5);
	
	cPrev = vec4(sin(a)*l+.5,sin(a)*l+.5,sin(a*1.0)*l+0.5,0.9);
	gl_FragColor = cPrev;
}