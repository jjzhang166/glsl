#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 light = vec3(3.0, 4.0, -5.0);

float hash(float t) {
	return fract(cos(t * 65537.0) * 65521.0);
}

float noise(vec3 p) {
	p = floor(p);
	return fract( hash(sin(p.x)) + hash(sin(p.y)) + hash(sin(p.z)) - hash((sin(p.x * 2.0) + sin(p.y * 3.0) + sin(p.z * 5.0)))); 	
}

float snow(vec2 p) {
	vec2 f = fract(p);
	p -= f;
	return mix(
		mix(noise(p.xyx), noise(vec2(p.x + 1.0, p.y).xyx), f.x),
		mix(noise(vec2(p.x, p.y + 1.0).xyx), noise(p.xyx + 1.0), f.x),
		f.y	
	);
}

float perlin(vec2 p) {
	float r = 0.0;
	r += 0.500000 * snow(p); p *= 5.0/2.0;
	r += 0.250000 * snow(p); p *= 7.0/3.0;
	r += 0.125000 * snow(p); p *= 11.0/5.0;
	r += 0.062500 * snow(p); p *= 15.0/7.0;
	r += 0.031250 * snow(p); p *= 23.0/11.0;
	r += 0.031250 * snow(p); p *= 27.0/13.0;
	return r;
}

vec3 trace(vec3 ori, vec3 dir, int iter) {
	if (iter < 0)
		return vec3(0.0);
	
	
	float t = -2.0 / dir.y;
	
	if (t > 0.0) {
		vec3 gnd = ori + t * dir;
	
		mat2 roty = mat2(cos(time), -sin(time), sin(time), cos(time));
		
		gnd.xz = roty * gnd.xz;
		ori.xz = roty * ori.xz;
		
		
		vec2 uv = gnd.xz;

		
		float c = mod(floor(uv.x) + floor(uv.y), 2.0);
	
		return
			vec3(0.4 + 0.2 * c, 1.0-c, c) *
			(0.6 + 0.4 * noise(gnd * 65536.0)) *
			(0.5 + 0.5 * dot(
				vec3(0.0, 1.0, 0.0),
				normalize(light - gnd)
			) + 
			0.0//0.2 * trace(gnd, reflect(dir, vec3(0.0, 1.0, 0.0)), iter - 1)
			);
	}

	t = 50.0 / dir.y;
	
	if (t > 0.0) {
		vec3 gnd = ori + t * dir;
	
		vec2 uv = gnd.xz / 20.0 + vec2(-time, 0.0);
		
		float c = mod(floor(uv.x) + floor(uv.y), 2.0);
	
		return vec3(.6, .6, .5) + (0.1 * clamp(perlin(uv) * 5.0 - 2.0, 0.0, 1.0));
	}
			
	return vec3(0);
}

void main( void ) {
	vec2 pos = ( gl_FragCoord.xy / resolution.xy ) * 2.0 - 1.0;
	pos.x *= resolution.x / resolution.y;
	
	gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
	
	vec3 ori = vec3(0.0, 0.0, 5.0);
	vec3 dir = normalize(vec3(2.0 * pos, -1.0));
	
	gl_FragColor = vec4(trace(ori, dir, 5), 1.0);
}