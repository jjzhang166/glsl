#ifdef GL_ES
precision mediump float;
#endif

// simplify
// + anti-aliasing
// + simplify even more

// code golf??

uniform vec2 mouse;
uniform vec2 resolution;

void main(void) {
	float e = resolution.x*0.075;  // eye size relative to screen
	float b = e*0.35;              // pupil size relative to eye size
	vec2 m = resolution*vec2(0.5); // position of eyes
	m.x += ((gl_FragCoord.x<m.x)?-e:e)*1.05; // 1.05 for a gap between eyes
	vec2 t = mouse*resolution-m;
	m -= gl_FragCoord.xy;
	gl_FragColor = vec4(min(e-length(m),length(m+t/max(2.0,length(t)/(e-b)))-b));
}