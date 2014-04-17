#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

varying vec2 surfacePosition;

#define MAX_ITERATION 300
#define SCALE .006967816248445938
#define CENTER vec2(-.7439073267881252, .10225932384607081)
#define BAILOUT 3.
#define EXTRA_ITER 4

#define DEFAULT_COLOR vec3(.0, .0, .0)
#define COLOR_WIDTH .04
#define BRIGHTNESS -0.3
#define CONTRAST 1.5

void Z_n(inout vec2 Z, vec2 C) {
	float xtemp = Z.x * Z.x - Z.y * Z.y + C.x;
	Z.y = 2. * Z.x * Z.y + C.y;
	Z.x = xtemp;
}

float colorBand(float x, float start, float width) {
	return (cos(x * width + start) / 2. + 0.5 + BRIGHTNESS) * CONTRAST;
}

vec3 computeColor(float x) {
	float r = colorBand(x, 2.0943951023931953, COLOR_WIDTH); // 2PI/3
	float g = colorBand(x, 3.141592653589793, COLOR_WIDTH); // PI
	float b = colorBand(x, 4.1887902047863905, COLOR_WIDTH); // 4PI/3
	return vec3(r, g, b);
}

void main( void ) {
	vec2 C = SCALE * surfacePosition + CENTER;
	vec2 Z = vec2(0., 0.);
	
	vec3 color = DEFAULT_COLOR;
	
	for (int i = 0; i < MAX_ITERATION; i++) {
		Z_n(Z, C);
		if (length(Z) >= BAILOUT) {
			for (int j = 0; j < EXTRA_ITER; j++) {
				Z_n(Z, C);
			}
			float density = float(i + EXTRA_ITER) - log2(log(length(Z)) / log(BAILOUT));
			color = computeColor(density);
			break;
		}
	}
	
	gl_FragColor = vec4(color, 1.);
}