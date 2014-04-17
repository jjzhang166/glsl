#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 Rotate(vec2 p, float a) {
	return vec2(p.x*cos(a) - p.y*sin(a), p.x*sin(a) + p.y*cos(a));
}

float Circle(vec2 p, vec2 at, float size) {
	p -= at;
	return step(length(p), size);
}

float Box(vec2 p, vec2 at, vec2 size) {
	p -= at;
	vec2 d = abs(p) - size;
  	return step(min(max(d.x, d.y), 0.) + length(max(d, 0.)), 0.0);
}

float Car(vec2 p, vec2 at) {
	float c = max(Box(p, at, vec2(0.2, 0.1)), Circle(p, vec2(at.x-0.12, at.y-0.1), 0.05));
	c = max(c, Circle(p, vec2(at.x+0.12, at.y-0.1), 0.05));
	return c;	
}

float Map(vec2 p) {
	float c = 1.0;
	c = min(c, 1.-Box(p, vec2(0., 0.05), vec2(0.7, 0.2)));
	return c;	
}

void main( void ) {
	vec2 p=(gl_FragCoord.xy/resolution.y)*1.0;
	p.x-=resolution.x/resolution.y*0.5;
	p.y-=0.5;
	
	float angle = sin(time*2.)/8.;
	p = Rotate(p, angle);
	
	float c = 0.;
	c = max(Car(p, vec2(sin(time*2. - 1.5)*0.5, 0)), Map(p));
	c = min(c, 0.4);
	
	gl_FragColor = vec4(c, c, c, 0);

}