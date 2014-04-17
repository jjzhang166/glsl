#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

int julia (float x, float y, float cr, float ci) {
	float xx = x * x, yy = y * y;
	int n = 0;
	for (int i = 0; i < 360; i ++) {
		y = (x + x) * y + ci;
		x = xx - yy + cr;
		yy = y * y;
		xx = x * x;
		if (xx + yy > 400.0 || i == 30) {
			n = i;
			break;
		}
	}
	return n;
}
void main( void ) {
	vec2 position = (gl_FragCoord.xy / resolution.xy) * 4.0;
	vec2 size = position;
	float real = 0.2;
	float image = 0.2;
	int n = julia(size.x, size.y, real, image);
	if (n != 30) {
		gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);
	} else {
		gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
	}

}