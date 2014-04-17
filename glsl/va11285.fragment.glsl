#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.1415926535

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main(void) {

	vec2 p = gl_FragCoord.xy / resolution.y;
	p.y -= 0.5;
	p.x -= 0.5*resolution.x/resolution.y;
	
	float an = mod(atan(p.y, p.x), PI/4.);
	float l = 0.3/(length(p) + an/4.);
	float c = step(mod(l+time, 1.0), 0.05);
	c = min(c, 0.4);

	gl_FragColor = vec4(c, c, c, 0.);

}