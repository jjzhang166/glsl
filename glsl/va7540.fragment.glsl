#version 150
uniform sampler2D tex;
in vec2 fragTexCoord;
out vec4 finalColor;

struct Ray3 {
	vec3 point;
	vec3 direction;
};

struct Plane3P {
	vec3 point;
	vec3 paramS;
	vec3 paramT;
};

struct Plane3N {
	vec3 point;
	vec3 normal;
};

struct AABB2 {
	vec2 aa;
	vec2 bb;
};


Plane3N plane = Plane3N(
	vec3(0.0, 0.0, 1.0),
	vec3(0.0, 0.0, -1.0)
);

Ray3 eye = Ray3(
	vec3(0.5, 0.5, -10.0),
	vec3(fragTexCoord.x, fragTexCoord.y, 0.0)
);

AABB2 rect = AABB2(
	vec2(0.0, 0.0),
	vec2(1.0, 1.0)
);

float linePlaneIntersection(Ray3 ray, Plane3N plane) {
	float n1 = dot(vec4(ray.direction, 1.0), vec4(plane.normal, 1.0));

	if(n1 == 0) {
		return 0.0;
	}

	n1 = 1.0 / n1;
	float n2 = dot(vec4(ray.point, 1.0), vec4(plane.normal, 1.0));

	float result = n2 * n1;

	return result;
}

void main() {

	float point = linePlaneIntersection(eye, plane);


	finalColor = vec4(point * 1.0, 0.0, 0.0, 1.0);
}