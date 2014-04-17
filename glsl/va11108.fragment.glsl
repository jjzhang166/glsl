#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float Pacman(vec2 p, vec2 a) {
	p -= a;
	float l = length(p);
	float an = atan(p.y, p.x)*180./PI + 180.;
	float e = abs(mod(time, 0.3)-0.15)*300.;
	if(an > 180.-e && an < 180.+e) {
		return 0.;	
	}
	return step(l, 0.1);
}

void main( void ) {
	vec2 p = (gl_FragCoord.xy / resolution.y);
	p.x -= resolution.x/resolution.y*0.5;
	p.y -= 0.5;
	
	float c = 0.;
	c += Pacman(p, vec2(mod(time, 3.)-1.5, 0));
	c = min(c, 0.4);
	
	gl_FragColor = vec4(c, c, c, 0);
}