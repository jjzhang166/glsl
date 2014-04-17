#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.1415926

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float Rect(vec2 p, vec2 a, vec2 s) {
	p -= a;
	p = mod(p, (sin(time))/4. + 0.28);
	if(abs(p.x) <= s.x/2. && abs(p.y) <= s.y/2.) {
		return 1.;	
	}
	return 0.;
}

vec2 Rotate(vec2 p, float a) {
	return vec2(cos(a)*p.x - sin(a)*p.y, sin(a)*p.x + cos(a)*p.y);
}

void main( void ) {

	vec2 p = (gl_FragCoord.xy / resolution.y);
	p.x -= 0.5*resolution.x/resolution.y;
	p.y -= 0.5;
	
	p = Rotate(p, sin(time/4.)*4.);
	p.y += mod(time, 1.);
	
	float c = 0.;
	c += Rect(p, vec2(0, 0), vec2(0.04, 0.04));
	c = min(c, 1.0);

	gl_FragColor = vec4(c*sin(time*2.7), c*sin(time*2.7 + 2./3.*PI), c*sin(time*2.7 + 4./3.*PI), 0.);
}