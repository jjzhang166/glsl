#ifdef GL_ES
precision highp float;
#endif

// Use your mouse to steer while zooming in!

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

#define FREQ 0.2
vec4 color(float marker) {
	float r = (1.0 + sin(FREQ * marker + 3.0)) / 2.0;
	float g = (1.0 + sin(FREQ * marker + 5.0)) / 2.0;
	float b = (1.0 + sin(FREQ * marker + 7.0)) / 2.0;
	
	return vec4(r, g, b, 1.0);
}

vec4 EncodeRGBA(float value) {
	value = clamp(value + 128.0, 0.0, 255.0);
	//return vec4(0.0,0.0,0.0,0.0);
	vec4 encoded = vec4(0.0, 0.0, 0.0, 0.0);
	encoded.r = floor(value) / 255.0;
	encoded.g = floor(mod(value, 1.0) * 255.0) / 255.0;
	encoded.b = floor(mod(value * 255.0, 1.0) * 255.0) / 255.0;
	encoded.a = floor(mod(value * (255.0 * 255.0), 1.0) * 255.0) / 255.0;
	return encoded;
}

float round(float value) {
	return sign(value) * floor(abs(value)+0.5);
}

vec4 PixelAt(int x, int y) {
	vec2 pixel = 1./resolution;
	return texture2D(backbuffer, vec2(float(x), float(y)) / resolution);
}

float DecodeRGBA(vec4 color) {
	if (color == vec4(0.0, 0.0, 0.0, 0.0)) {return 0.0;}

	float value = round(color.a * 255.0) / (255.0 * 255.0 * 255.0);
	value += round(color.b * 255.0) / (255.0 * 255.0);
	value += round(color.g * 255.0) / 255.0;
	value += round(color.r * 255.0) - 128.0;
	return value;
}

#define ITERATIONS 1000
void main() {
	vec2 coord = gl_FragCoord.xy / resolution.xy;
	//vec2 offset = mouse * 2.0 - 1.0;
	//vec2 offset = vec2(0.1, -0.1);
	vec2 offset = vec2(DecodeRGBA(PixelAt(1, 1)), DecodeRGBA(PixelAt(6, 1)));

	vec2 z, z0, zT;
	float t = mod(time, 1000.0);
	float scaling = pow(2.5, 1.0 + -0.2 * t);
	if (t < 0.2) {
		offset = vec2(0.0);
	} else if (t < 2.0) {
		offset *= t / 2.0;
	}

	offset += (mouse - 0.5) * 0.05 * scaling;

	z0.x = offset.x + 1.3333 * (coord.x - 0.5) * scaling - 0.7;
	z0.y = offset.y + (coord.y - 0.5) * scaling;

	if (length (gl_FragCoord.xy - vec2(1, 1)) < 1.9) {
		gl_FragColor = EncodeRGBA(offset.x);
		return;
	} else if (length (gl_FragCoord.xy - vec2(6, 1)) < 1.9) {
		gl_FragColor = EncodeRGBA(offset.y);
		return;
	}

	float F;
	for(int i = 0; i < ITERATIONS; i++) {
		if(dot(z,z) > 4.0) break;
		zT.x = (z.x * z.x - z.y * z.y) + z0.x;
		zT.y = (z.y * z.x + z.x * z.y) + z0.y;
		z = zT;
		F++;
	}
	gl_FragColor = (F == float(ITERATIONS)) ? vec4(0.0, 0.0, 0.0, 1.0) : color(F - log2(log2(dot(z,z))));
}
	