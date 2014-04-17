#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//
// Find graph coordinate. Vertex shaders would be better for this.
//

const vec2  bounds_min    = vec2(-2, -1);
const vec2  bounds_max    = vec2(1, 1);
const vec2  bounds_size   = bounds_max - bounds_min;
const float bounds_aspect = bounds_size.x / bounds_size.y;

vec2 project (vec2 coord) {
	float screen_aspect = resolution.x / resolution.y;
	float scale;
	vec2  trans;
	
	if (screen_aspect >= bounds_aspect) {
		scale = bounds_size.y / resolution.y;
		trans = bounds_min + vec2((bounds_min.x + bounds_max.x) / 2.0, 0.0);
	} else {
		scale = bounds_size.x / resolution.x;
		trans = bounds_min + vec2(0.0, (bounds_min.y + bounds_max.y) / 2.0);
	}
	
	return coord * scale + trans;
}

vec2 cpx_mul (vec2 a, vec2 b) {
	return vec2(a.x * b.x - a.y * b.y, a.x * b.y + a.y * b.x);
}

//
// Mandelbrot set
//

const int max_iters = 100;

float count_escape (vec2 coord) {
	vec2 z = coord;
	
	for (int i = 0; i < max_iters; i++) {
		z = cpx_mul(z, z) + coord;
		if (abs(z.x) > 2.0) {
			return float(i) + 1.0 - log(log(abs(z.x))) / log(2.0);
		}
	}
	return 0.0;
}

//
// Main
//

const float lum_exp = 1.0;
const vec3  color   = vec3(1.3, 0.6, 0.2);

void main () {
	float rate      = mouse.y;
	float magnitude = mouse.x;
	vec2  coord     = project(vec2(gl_FragCoord));
	float lum       = pow(count_escape(coord) / float(max_iters), lum_exp);
	gl_FragColor    = vec4(color * lum, 1.0);
}