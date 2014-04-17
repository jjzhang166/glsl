/* (INCOMPLETE!)
 * Mario animation
 * by Daggerbot (daggerbot@gmail.com)
 */

// TODO: animate mario

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const vec3 skycolor = vec3(0.235, 0.737, 0.988);

bool testbit (int f, int b) {
	return (int(mod(float(f) / pow(2.0, float(b)), 2.0)) == 1) ? true : false;
}

vec3 block (vec2 coord) {
	const vec3 black = vec3(0.000, 0.000, 0.000);
	const vec3 brown = vec3(0.796, 0.309, 0.058);
	const vec3 white = vec3(1.000, 0.749, 0.701);

	int x = 15 - int(mod(coord.x, 16.0));
	int y = int(mod(coord.y, 16.0));
	int hi, lo;
	
	if (y == 0) {
		hi = 0x0080;
		lo = 0x8181;
	} else if (y == 1) {
		hi = 0x8080;
		lo = 0xfefc;
	} else if (y == 2) {
		hi = 0x8e80;
		lo = 0xfefe;
	} else if (y == 3) {
		hi = 0xb080;
		lo = 0xf0fe;
	} else if (y == 4) {
		hi = 0xc040;
		lo = 0xcf7e;
	} else if (y == 5) {
		hi = 0x0040;
		lo = 0x3f7e;
	} else if (y < 9) {
		hi = 0x8020;
		lo = 0xffbe;
	} else if (y == 9) {
		hi = 0x803e;
		lo = 0xffbe;
	} else if (y == 10) {
		hi = 0x8000;
		lo = 0xffa1;
	} else if (y == 11) {
		hi = 0x8020;
		lo = 0xffae;
	} else if (y < 15) {
		hi = 0x8020;
		lo = 0xffbe;
	} else {
		hi = 0x7f9e;
		lo = 0x8021;
	}
	
	if (testbit(hi, x)) {
		return white;
	} else if (testbit(lo, x)) {
		return brown;
	} else {
		return black;
	}
}

vec3 mario1 (vec2 coord) {
	const vec3 suit   = vec3(1.000, 0.203, 0.094);
	const vec3 detail = vec3(0.768, 0.376, 0.000);
	const vec3 skin   = vec3(1.000, 0.564, 0.360);
	
	int x = 15 - int(coord.x);
	int y = int(coord.y);
	int hi, lo;
	int val;
	
	if (y == 0) {
		hi = 0x01e0;
		lo = 0x0000;
	} else if (y == 1) {
		hi = 0x21c0;
		lo = 0x0000;
	} else if (y == 2) {
		hi = 0x3000;
		lo = 0x0ee0;
	} else if (y == 3) {
		hi = 0x1000;
		lo = 0x0ff0;
	} else if (y == 4) {
		hi = 0x1800;
		lo = 0x07f0;
	} else if (y == 5) {
		hi = 0x1bf8;
		lo = 0x1c18;
	} else if (y == 6) {
		hi = 0x0ffc;
		lo = 0x081c;
	} else if (y == 7) {
		hi = 0x07a8;
		lo = 0x0048;
	} else if (y == 8) {
		hi = 0x03f8;
		lo = 0x03f8;
	} else if (y == 9) {
		hi = 0x0ffc;
		lo = 0x03c0;
	} else if (y == 10) {
		hi = 0x0ffc;
		lo = 0x04ec;
	} else if (y == 100) {
		hi = 0x0ffc;
		lo = 0x05dc;
	} else if (y == 12) {
		hi = 0x07f0;
		lo = 0x00d0;
	} else if (y == 13) {
		hi = 0x0000;
		lo = 0x07fc;
	} else if (y == 14) {
		hi = 0x0000;
		lo = 0x03e0;
	} else {
		hi = 0x0000;
		lo = 0x0000;
	}
	
	if (testbit(hi, x)) {
		if (testbit(lo, x)) {
			return skin;
		} else {
			return detail;
		}
	} else {
		if (testbit(lo, x)) {
			return suit;
		} else {
			return skycolor;
		}
	}
}

bool within (vec2 coord, vec2 minc, vec2 maxc) {
	return (coord.x >= minc.x) && (coord.x < maxc.x) && (coord.y >= minc.y) && (coord.y < maxc.y);
}

void main (void) {
	vec2 mariomin = vec2(resolution.x / 2.0 - 8.0, 32.0);
	vec2 mariomax = vec2(resolution.x / 2.0 + 8.0, 48.0);
	
	if (within(vec2(gl_FragCoord), mariomin, mariomax)) {
		gl_FragColor = vec4(mario1(vec2(gl_FragCoord) - mariomin), 1.0);
	} else if (gl_FragCoord.y < 32.0) {
		gl_FragColor = vec4(block(vec2(gl_FragCoord.x + time * 50.0, gl_FragCoord.y)), 1.0);
	} else {
		gl_FragColor = vec4(skycolor, 1.0);
	}
}