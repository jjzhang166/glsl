#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265357989

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float nsin(float x) { return sin(x)*0.5+0.5; }
float ncos(float x) { return cos(x)*0.5+0.5; }

float rect(vec2 p, float x0, float y0, float x1, float y1) {
	float col = 0.0;
	
	if(p.x >= x0 && p.y >= y0 && p.x <= x1 && p.y <= y1) {
		col += 1.0;
	}
	return col;
}

float wavy1(vec2 p) {
	float c = 0.0;
	c = 1. - ncos(4.*PI*(p.y+time));
	return c;
}

float line(vec2 p, float b, float m) {
	float c = 0.0;
	float d = 0.003;
	float yy;
	
	//if(p.y == b * p.x + m) c = 1.0;
	yy = b * p.x + m;
	if(p.y <= yy+d && p.y >= yy-d) c = 1.0;
	return c;
}
	

void main( void ) {

	vec2 pos = ( gl_FragCoord.xy / resolution.xy );

	float color = 0.0;
	
	// the diagonal gradient
	color += 0.5*(pos.x  + pos.y);

	color += rect(pos, 0.1, 0.3, 0.4, 0.4);
	//color = 0.0;
	
	gl_FragColor = vec4(color, line(pos, tan(time), 0.5), wavy1(pos), 0.11 );
}