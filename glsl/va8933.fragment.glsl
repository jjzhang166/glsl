#ifdef GL_ES
precision mediump float;
#endif
uniform float time;
uniform vec2 mouse;
float hex(vec2 p) {
	p.y += abs(mod(floor(p.x), 4.)*1.5);
	p = abs((mod(p, 1.) - .5));
	return abs(max(p.x*1.5 + p.y, p.y*2.) - 1.);
}
void main(void) { 
	vec2 pos = gl_FragCoord.xy;
	pos.x += 15. * (2.*fract(mouse.x) + time);
	pos.y += 15. * (2.*mouse.y + abs(5.*sin(time)));
	vec2 p = pos/50.;
	float  r = .05;
	gl_FragColor = vec4(smoothstep(.06, r, hex(p)));
}