#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.1415926

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float circle(vec2 pos, vec2 at, float size) {
	pos -= at;
	float a = atan(pos.y, pos.x);
	float l = length(pos);
	return step(length(pos), size);
}

void main( void ) {
	vec2 p=(gl_FragCoord.xy/resolution.y)*1.0;
	p.x-=resolution.x/resolution.y*0.5;
	p.y-=0.5;
	
	float c=0.0;
	for(float i=0.0 ; i<11.0 ; i++) {
		float ct = mod(time*1.5+i/10.0, 2.0);
		float ypos = 1.0-(abs(1.0 + ct*ct - 2.0*ct)) - 0.5;
		c += circle(p, vec2(i/5.0-1.0, ypos), 0.1);
		c += circle(p, vec2(i/5.0-1.0, -ypos), 0.1);
	}
	c = min(c, 0.5);
	gl_FragColor = vec4(c*sin(time), c*sin(time+PI*2.0/3.0), c*sin(time+PI*4.0/3.0), 0);

}