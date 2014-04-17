#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define ZNEAR 1.0
#define ZFAR 5.0
#define PI 3.14159265359

struct hit {
	float dist;
	vec3 pos;
	vec3 normal;
};

hit sphere(vec3 orig, vec3 dir, vec3 center, float radius) {
	float a = dot(dir, dir);
	float b = 2.0 * dot(dir, orig - center);
	float c = dot(orig - center, orig - center) - radius * radius;
	
	float d = b * b - 4.0 * a * c;
	
	hit h;
	h.dist = -1.0;
	
	if (d < 0.0) { return h; }
	
	float dist = (-b - sqrt(d)) / (2.0 * a);
	
	if (dist < 0.0) { return h; }
	
	h.dist = dist;
	h.pos = orig + dir * dist;
	h.normal = (center - h.pos) / radius;
	return h;
}

void main(void) {
	vec2 position = gl_FragCoord.xy / resolution;
	
	position -= 0.5;
	position.x /= resolution.y / resolution.x;
	
	vec3 orig = vec3(position, 0.0);
	vec3 dir = normalize(orig - vec3(0.0, 0.0, -ZNEAR));
	
	hit h;
	h.dist = -1.0;
	
	float mind = -1.0;
	for (int i = 0; i < 32; i++) {
		float a = 2.0 * PI / 64.0 * float(i) + time * 2.3;
		hit sh = sphere(orig, dir, vec3(cos(a), sin(a)*float(i) / 16.0, 3.0), 0.2);
		if (sh.dist >= 0.0 && (mind == -1.0 || sh.dist < mind)) {
			h = sh;
			mind = sh.dist;
		}
	}
	
	float a = time * 0.8;
	float r = 3.0;
	vec3 lightPos = vec3(cos(a) * r, cos(a) * sin(a) * r, sin(a) * r) * r;
	vec3 lightDir = normalize(h.pos - lightPos);
	
	if (h.dist == -1.0) {
		float lightProj = dot(orig - lightPos, dir);
		
		if (lightProj < 0.0) {
			float lightDist = length((orig - lightPos) - lightProj * dir);
			gl_FragColor = vec4(vec3(pow(lightDist, -2.0) / 10.0), 1.0);
		}
	}
	else {	
		vec3 eyeDir = -dir;

		float isqr = 100.0 / (4.0 * PI * distance(h.pos, lightPos));
		
		float ambient = 0.2;
		
		float diffuse = max(dot(lightDir, h.normal), 0.0);
		
		float specular = 0.5 * pow(max(dot(reflect(lightDir, h.normal), eyeDir), 0.0), 10.0);
	
		float radiance = min(1.0, (ambient + diffuse) / isqr);
		float highlight = min(1.0, specular / isqr);
		
		gl_FragColor = vec4(mix(vec3(radiance, 0.0, 0.0), vec3(1.0), highlight), 1.0);
	}
}