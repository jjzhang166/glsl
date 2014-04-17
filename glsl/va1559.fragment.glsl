// by @301z

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;
uniform sampler2D backbuffer;

const float pi = 3.14159;

float tex(in vec2 uv) {
	return pow(sin(uv.x * pi), 1.7) * 0.5; // FIXME!
}

void main() {
	vec3 p = vec3(vec2(gl_FragCoord.x, resolution.y - gl_FragCoord.y) - resolution * 0.5, resolution.x * 0.75);
	float t = (time + 1234.5) * 12.0;
	float rot = t * 0.05;
	float s = sin(rot);
	float c = sin(rot + pi * 0.5);
	float x = c * p.y - s * p.x;
	float y = c * p.x + s * p.y;
	float z = y * s + c * p.z;
	vec2 v = vec2(0.0, t / 32.0);
	vec2 uv = vec2(atan(z, x), (y * c - s * p.z) / sqrt(x * x + z * z)) * 0.5 / pi;
	vec2 f0 = fract(v + uv);
	vec2 f1 = fract(v + uv * 4.0);
	vec2 f2 = fract(v + uv * 8.0);
	float i0 = fract(tex(f0) - 5.0 / 255.0);
	float i1 = fract(tex(f1) - 16.0 / 255.0);
	float i2 = fract(tex(f2) - 48.0 / 255.0);
	float i = mix(i0, mix(i1, i2, step(0.5, fract(f1.y - f1.x))), step(0.25, mod(f0.x + f0.y, 0.5)));
	vec3 c0  = mix(vec3(i + i, i * i * 4.0, 0.0), vec3(0.0, 2.0 - i - i, 1.0 - i), step(0.5, i));
	vec3 c1 = texture2D(backbuffer, gl_FragCoord.xy / resolution).rgb;
	gl_FragColor = vec4(mix(c0, c1, 0.25), 1.0);
}
