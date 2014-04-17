#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float Circle(vec2 p, vec2 a, float s) {
	p -= a;
	return step(mod(length(p), (sin(time)+1.)/10. + 0.05), s);
}

void main( void ) {

	vec2 p = (gl_FragCoord.xy / resolution.y);
	p.x -= resolution.x/resolution.y*0.5;
	p.y -= 0.5;
	
	float c = 0.;
	for(float i=0. ; i<16. ; i++) {
		float of = 9999999.*time+2.*PI*i/16.+time*.1;
		float op = 0.2*Circle(p, vec2(cos(cos(time/4.)*8.+of), sin(cos(time/4.)*8.+of))*((cos(time)+1.)/2.+0.1), 0.005);
		c += op;
	}
	
	gl_FragColor = vec4(sin(time)*c, sin(time+2./3.*PI)*c, sin(time+4./3.*PI)*c, 0);
}