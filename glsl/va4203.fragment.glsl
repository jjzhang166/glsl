#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 wave(vec2 p, float t) {
	vec2 p2;
	p2.x = p.x;
	p2.x += 0.4 * sin ( t*2.0 + p.y*1.0 );
	p2.x += 0.4 * cos ( t*1.8 + p.y*3.5 );
	p2.y = p.y;// - 0.5 * cos (t*2.0 + p.y*2.0);
	return p2;
}

float crad(vec2 p, float offset) {
	float t = (time*2.0 + offset) / 2.0;
	vec2 p2 = wave(p, t/3.0);
	vec2 c = vec2(
		0.5 + (0.2 * sin(t / 1.0)) + (0.2 * cos(t / 1.1)),
		0.5 + (0.2 * cos(t / 1.5)) + (0.2 * sin(t / 0.8))
	);
	vec2 d = c - p2;
	return sqrt(d.x*d.x + d.y*d.y);
}

int ramp(float z) {
	return int(mod(z * 55.0, 2.0));
}

int xor(int a, int b) {
	int t = 0;
	t += a;
	t += b;
	int o = 0;
	if (t==1) o=1;
	if (t==3) o=1;
	return o;
}

float rings(vec2 position, float t) {
	int aout = xor(
		ramp(crad(position, 1.0-t )),
		ramp(crad(position, 8.0-t )));
	return float(aout) ;
} 

void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	float color = 0.0;
	color += rings(position, 0.0)*1.0;
	color += rings(position, 1.0)*0.4;
	color += rings(position, 2.0)*0.1;
	color /= 5.0;
	gl_FragColor = vec4( color*0.7, color*0.9, color*1.0, 1.0 );
}