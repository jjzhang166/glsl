#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define MAX_ITERATION 100
#define SCALE 3.
#define X 1.5
#define Y .5
#define DEFAULT_DENSITY 0.
#define BRIGHTNESS .0
#define CONTRAST .1
#define COLOR vec3(.2, .4, 1.)

void Z_n(inout vec2 Z, vec2 C) {
	float xtemp = Z.x * Z.x - Z.y * Z.y + C.x;
	Z.y = 2. * Z.x * Z.y + C.y;
	Z.x = xtemp;
}

void main( void ) {
	float x0 = SCALE * (gl_FragCoord.x / resolution.y - X);
	float y0 = sin(mouse.y*mouse.y)*SCALE * (gl_FragCoord.y / resolution.y - Y);
                             	
	vec2 C = vec2(x0, y0);
	vec2 Z = vec2(0., 0.);
	
	float density = DEFAULT_DENSITY;
	
	for (int i = 0; i < MAX_ITERATION; i++) {
		Z_n(Z, C);
		if (length(Z) >= 2.) {
			Z_n(Z, C);
			Z_n(Z, C);
			Z_n(Z, C);
			density = float(i + 3) - log2(log2(length(Z)));
			break;
		}
	}
	
	gl_FragColor = vec4(sin(mouse.x*mouse.y)*COLOR * (density * CONTRAST + BRIGHTNESS), 1.1);
}