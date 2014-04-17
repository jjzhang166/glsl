#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define max_steps 64
#define epsilon 0.003

const vec3 UNIT_X = vec3(1.0, 0.0, 0.0);
const vec3 UNIT_Y = vec3(0.0, 1.0, 0.0);
const vec3 UNIT_Z = vec3(0.0, 0.0, 1.0);
const float M_PI = 3.14159;

struct Material {
	vec3 color;
	float diffuse;
};
struct Sphere {
	vec3 position;
	float radius;
	Material material;
};

#define num_spheres 2
Sphere SPHERES[2];

vec3 light = normalize(vec3(0.25, 1.0, -0.5));

float smin( float a, float b, float k ) {
	float h = clamp( 0.5+0.5*(b-a)/k, 0.0, 1.0 );
    	return mix( b, a, h ) - k*h*(1.0-h);
}

float sphere(vec3 p, Sphere s) {
	return length(p - s.position) - s.radius;
}
float distance(vec3 p) {
	float s1 = sphere(p, SPHERES[0]);
	float s2 = sphere(p, SPHERES[1]);
	return smin(s1, s2, 0.2);
}

vec3 gradient(vec3 p) {
	return normalize(vec3(
		distance(p + UNIT_X*epsilon) - distance(p - UNIT_X*epsilon),
		distance(p + UNIT_Y*epsilon) - distance(p - UNIT_Y*epsilon),
		distance(p + UNIT_Z*epsilon) - distance(p - UNIT_Z*epsilon)));
}

vec3 shade(vec3 p) {
	vec3 normal = gradient(p);
	float diffuse = clamp(dot(normal, light), 0.0, 1.0);
	
	return diffuse*vec3(1.0, 1.0, 1.0);
}

vec3 raycast(vec3 ro, vec3 rd) {
	float d = 1.0, delta;
	int j = 0;
	for(int i = 1; i <= max_steps; i++) {
		delta = distance(ro + rd*d);
		if(delta < epsilon) break;
		d += delta;
		j = i;
	}
	if(j < max_steps) {
		return shade(ro + rd*d);
	}
	return vec3(0.0);
}

void main(void) {
	vec2 fragment = vec2((gl_FragCoord.x - resolution.x*0.5)/resolution.y, gl_FragCoord.y/resolution.y - 0.5);
	vec3 ro = vec3(0, 0, -2);
	vec3 rd = normalize(vec3(fragment, 0) - ro);
	
	SPHERES[0] = Sphere(
		vec3(-cos(time*M_PI*0.5)*0.5 - 0.85, 0.0, 5.0),
		1.0,
		Material(vec3(1.0), 1.0)
	);
	SPHERES[1] = Sphere(
		vec3(0.5, sin(time)*0.5, 5.0),
		0.75,
		Material(vec3(1, 0, 0), 0.8)
	);
	
	light = normalize(vec3(mouse.xy - 0.5, -0.5));
	
	gl_FragColor = vec4(raycast(ro, rd), 1);
}