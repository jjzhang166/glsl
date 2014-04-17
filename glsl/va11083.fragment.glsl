#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float circle(vec2 pos, vec2 at, float size) {
	pos -= at;
	float l = length(pos);
	return step(l, size);
}

void main( void ) {
	vec2 p=(gl_FragCoord.xy/resolution.y)*1.0;
	p.x-=resolution.x/resolution.y*0.5;p.y-=0.5;
	
	float c = 0.0;
	for(float i=0.0 ; i<9.0 ; i++) {
		c += circle(p, vec2(cos(time*2.1+2.0*PI*i/16.0), sin(time*2.0+2.0*PI*i/8.0))*0.2, 0.1);	
	}
	c = min(c, 0.2);
	gl_FragColor = vec4(c, c, c, 0);
}