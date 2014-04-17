#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// http://www.fractalforums.com/new-theories-and-research/very-simple-formula-for-fractal-patterns/
float field(in vec3 p) {
	float strength = 7. + .03 * log(1.e-6 + fract(sin(time) * 4373.211));
	float accum = 0.;
	float prev = 0.;
	float tw = 0.;
	for (int i = 0; i < 32; ++i) {
		float mag = dot(p, p);
		p = abs(p) / mag + vec3(-.51, -.4, -1.3);
		float w = exp(-float(i) / 10.);
		accum += w * exp(-strength * pow(abs(mag - prev), 2.3));
		tw += w;
		prev = mag;
	}
	return max(.1, 5. * accum / tw - .7);
}

vec4 cloud(vec2 coord, vec2 res, float time) {
	vec2 uv = 1.0 * coord / res - 1.0;
	vec2 uvs = uv * res / max(res.x, res.y);
	
	vec3 p = vec3(uvs / 4., 0) + vec3(2., -1.3, -1.);
	p += .1 * vec3(sin(time / 16.), sin(time / 12.),  sin(time / 128.));
	
	
	float t = pow(field(p), .9);
	
	return vec4(0., t * t, 1., 1.0);
}

void main( void ) {
	vec2 center = resolution / 2.;
	vec2 pos = gl_FragCoord.xy - center;
	float radius = resolution.x * .4;
	
	vec4 color = vec4(1., 1., 1., 1.);
	color -= cloud(gl_FragCoord.xy, resolution.xy, time) * .2;
	
	color *= 1. - smoothstep(radius - 1., radius + 1.0, length(pos));
	

	
	gl_FragColor = color;
}