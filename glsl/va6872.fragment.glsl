#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

float map(in vec3 p) {
	float f = length(p) - 2.0;
	float d =  max(f, length(p.xz) - 0.5);
	d = min(d, max(f, length(p.xy) - 0.5));
	d = min(d, max(f, length(p.zy) - 0.5));
	d = min(max(-f - 0.5, d), max(-d, f + 1.0));
	vec4 fp = abs(vec4(d - 0.25, p));
	const float r = 0.1;
	const float k = 0.8;
	d = min(d, (length(fp.xy) - r) * k);
	d = min(d, (length(fp.xz) - r) * k);
	d = min(d, (length(fp.xw) - r) * k);
	
	return d;
}

vec3 getNormal(in vec3 p, in float s) {
	const vec2 e = vec2(0.0001, 0.0);
	return normalize(vec3(
		s - map(p + e.xyy),
		s - map(p + e.yxy),
		s - map(p + e.yyx)));
}

void main( void ) {
	vec2 position = -1.0 + 2.0 * (gl_FragCoord.xy / resolution.xy);
	vec3 camPos = vec3(sin(time) * 5.0, sin(time * 0.8) * 3.0, cos(time) * 5.0);
	const vec3 camTarget = vec3(0);
	vec3 camDir = normalize(camTarget - camPos);
	const vec3 camUp = vec3(0, 1, 0);
	vec3 u = cross(camDir, camUp);
	vec3 v = cross(camDir, u);
	vec3 rayDir = position.x * u + position.y * v + camDir;
	
	float dist = 0.0;
	float totalDist = 2.0;
	for (int i = 0; i < 50; i++) {
		dist = map(camPos + rayDir * totalDist);
		totalDist += dist;
		if (dist < 0.1 || totalDist > 5.0) {
			break;
		}
	}

	if (dist < 0.1) {
		vec3 p = camPos + rayDir * totalDist;
		vec3 n = getNormal(p, dist);
		float c = dot(n, rayDir);
		gl_FragColor = vec4(c) * normalize(abs(p.xyzz));	
	}
}