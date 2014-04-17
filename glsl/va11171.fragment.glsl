#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265358979323846264338327950

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 Rotate(vec2 p, float a) {
	return vec2(cos(a)*p.x - sin(a)*p.y, sin(a)*p.x + cos(a)*p.y);	
}

float Circle(vec2 p, vec2 a, float s) {
	p -= a;
	return step(length(p), s);
}

float Rect(vec2 p, vec2 a, vec2 s) {
	p -= a;
	if(abs(p.x) < s.x/2. && abs(p.y) < s.y/2.) {
		return 1.;	
	}
	return 0.;
}

float Fan(vec2 p, vec2 a) {
	p -= a;
	float an = mod(atan(p.y, p.x)+(time*4.), PI/2.);
	float c = step(length(p), an/32.);
	c = max(c, 0.3*Rect(p, vec2(0, -0.05), vec2(0.01, 0.1)));
	return c;
}

float House(vec2 p, vec2 a) {
	p -= a;
	float c = 0.;
	p += vec2(0., 0.05);
	c += Rect(p, vec2(0.0, 0.0), vec2(0.2, 0.2));
	p -= vec2(0.0, 0.1);
	p = Rotate(p, 45.*PI/180.);
	c = max(c, Rect(p, vec2(0.0, 0.0), vec2(0.2, 0.2)/sqrt(2.)));
	return c;
}

float Moon(vec2 p, vec2 a) {
	p -= a;
	float c = 0.;
	c = Circle(p, vec2(0, 0), 0.1) - 0.95*Circle(p, vec2(-0.05, 0), 0.1);
	return c;
}

float Water(vec2 p, vec2 a, vec2 s) {
	p -= a;
	if(abs(p.x) < s.x/2. && abs(p.y) < (s.y/2. + (sin(p.x*40. - time*4.)/42. * 2.*((abs(mod(time, 0.8) - 0.4))-0.2) ))) {
		return 1.;
	}
	return 0.;
}

float Cloud(vec2 p, vec2 a) {
	p -= a;
	float c = 0.;
	c += step((p.x*p.x + p.y*p.y*5.), 0.01);
	p += vec2(0.1, 0.03);
	c = max(c, step((p.x*p.x + p.y*p.y*5.), 0.01));
	p += vec2(0.1, -0.04);
	c = max(c, step((p.x*p.x + p.y*p.y*5.), 0.01));
	return c;
}

float Layer0(vec2 p) {
	float c = 0.;
	c += Rect(p, vec2(-1.3, -0.5), vec2(4.0, 0.5));
	c = max(c, Rect(p, vec2(-1.3 + 5., -0.5), vec2(4.0, 0.5)));
	c = max(c, Water(p, vec2(1.2, -0.5), vec2(1.0, 0.4)));
	c = max(c, Fan(p, vec2(0.2, -0.15)));
	c = max(c, House(p, vec2(-0.05, -0.15)));
	return c;	
}

float Layer1(vec2 p) {
	float c = 0.;
	c += 0.2*Cloud(p, vec2(mod(0.2+time/4., 6.0)-1.5, 0.2));
	return c;
}

float Layer2(vec2 p) {
	float c = 0.;
	c = max(c, Moon(p, vec2(0.3, 0.3)));
	return c;	
}


void main(void) {

	vec2 p = (gl_FragCoord.xy / resolution.y);
	p.x -= resolution.x/resolution.y*0.5;
	p.y -= 0.5;
	
	
	
	float c = 0.;
	c = Layer2(p);
	c = max(c, Layer1(vec2(p.x+mouse.x/2., p.y)));
	c = max(c, Layer0(vec2(p.x+mouse.x, p.y)));
	c = min(c, 0.4);

	gl_FragColor = vec4(c, c, c, 0.);

}