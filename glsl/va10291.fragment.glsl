#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// 2PI
#define COLOR_WIDTH 6.283185307179586

#define BRIGHTNESS -0.3
#define CONTRAST 1.5

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
	gl_FragColor = vec4(computeColor(gl_FragCoord.x / resolution.x), 1.0);

}