#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float crad(vec2 p, float offset) {
	float t = time*2.0 + offset;
	float cx = 0.5 + (0.2 * sin(t / 1.0)) + (0.2 * cos(t / 1.1)) - p.x;
	float cy = 0.5 + (0.2 * cos(t / 1.5)) + (0.2 * sin(t / 0.8)) - p.y;
	return sqrt(cx*cx + cy*cy);
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

void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	int a0 = ramp(crad( position, 1.0 ));
	int a1 = ramp(crad( position, 6.0 ));
	int aout = xor(a0, a1);
	float color = float(aout) * 0.33;
	gl_FragColor = vec4( color, color, color, 1.0 );
}