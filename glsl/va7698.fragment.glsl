#ifdef GL_ES
precision mediump float;
#endif

#define MAX_ITER 100
#define EPSILON 0.01
#define ASPECT_RATIO (resolution.x / resolution.y)
#define PI 3.141592653589
#define INFINITE 100000.0
#define LOG2 1.442695

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 cameraPos = vec3(0.0, 0.0, 5.0);

float dist_sphere(vec3 point, vec3 center, float radius) {
	vec3 d = point - center;
	return sqrt(d.x * d.x + d.y * d.y + d.z * d.z) - radius;
}

float dist_cube(vec3 point, vec3 center, vec3 size) {
	vec3 d = point - center;
	return max(max(abs(d.x) - size.x, abs(d.y) - size.y), abs(d.z) - size.z);
}

float scene(vec3 position, float minDistance) { 
	float d = 0.0;
	d = max(d, dist_cube(position, vec3(0.0, 0.0, 0.0), vec3(0.5)));
	d = max(d, -dist_sphere(position, vec3(0.0, 0.0, 0), 0.6));
	d = min(d, dist_cube(position, vec3(0.0, 0.0, 1.0), vec3(2.0, 2.0, 0.01)));
	d = min(d, dist_sphere(position, vec3(sin(time) * 0.6, 0.0, 0.0), 0.25));
	d = min(d, dist_sphere(position, vec3(0.0, cos(time) * 0.6, 0.0), 0.25));
	
	return  d;
}

bool trace(vec3 rayOrigin, vec3 rayDir, out vec3 position)
{
	float t = 0.0;
	position = vec3(0.0, 0.0, 0.0);
	float maxDistance = 100.0;
	float minDistance = 0.001;
	float distance = 0.0;

	for ( int i = 0; i < MAX_ITER; i++ ) {
		position = rayOrigin + t * rayDir;

		distance = scene(position, minDistance);

		if (abs(distance) < minDistance || t > maxDistance) { 
			break;
		}

		t += distance;  
	}

	return distance < minDistance;
}

vec3 computeNormal(vec3 point) {
	vec3 epsilonX = vec3(EPSILON, 0.0, 0.0);
	vec3 epsilonY = vec3(0.0, EPSILON, 0.0);
	vec3 epsilonZ = vec3(0.0, 0.0, EPSILON);
	
	float fDummy;
	vec3 diffNormal;
	diffNormal.x = scene(point + epsilonX, fDummy) - scene(point - epsilonX, fDummy);
	diffNormal.y = scene(point + epsilonY, fDummy) - scene(point - epsilonY, fDummy);
	diffNormal.z = scene(point + epsilonZ, fDummy) - scene(point - epsilonZ, fDummy);
	
	return normalize(diffNormal);
}

float ambienOcclusion(vec3 point, vec3 normal) {
	float multiplier = 4.0;
	float ao = 0.0;
	float decay = 1.0;
	const int steps = 8;
	float fDummy;
	int iDummy;
	for (int i = 0; i < steps; ++i) {
		float aoDist = multiplier * (float(i) / float(steps));
 		vec3 aoPoint = point + normal * (aoDist + 0.1);
		ao += decay * (aoDist - scene(aoPoint, fDummy));
 		decay *= 0.5;
	}
  	return clamp(1.0 - ao, 0.0, 1.0);
}

vec4 ApplyMaterial(int objectID, vec3 position, vec3 rayOrigin, vec3 rayDir) {
	// compute normals
	vec3 normal = computeNormal(position);

	// Ambien occlusion pass
 	float ao = ambienOcclusion(position, normal);

	float diffuseFactor = dot(normal, -rayDir);

	//return vec4(normal, 1.0);
	return vec4(diffuseFactor, diffuseFactor, diffuseFactor, 1.0);	
}

vec4 ApplyBackground(vec3 position, vec3 rayDir) {
	return vec4(0.0, 0.0, 0.0, 1.0); 
}

mat3 axis_x_rotation_matrix(float angle) {
	return mat3(1.0, 0.0, 0.0,
		    0.0, cos(angle), -sin(angle),
		    0.0, sin(angle), cos(angle));
}

mat3 axis_y_rotation_matrix(float angle) {
	return mat3(cos(angle), 0.0, sin(angle),
		    0.0, 1.0, 0.0,
		    -sin(angle), 0.0, cos(angle));
}

void main() {
	vec2 screen_space_coords = (gl_FragCoord.xy / resolution.xy) * 2.0 - 1.0;
	screen_space_coords.x *= ASPECT_RATIO;
	screen_space_coords.xy /= 1.0 + distance(mouse.xy, vec2(0.5, 0.5));
	
	vec2 screen_space_mouse_coords = (mouse.xy * 2.0 - 1.0) * 2.0;
	screen_space_mouse_coords.x *= ASPECT_RATIO;
	screen_space_mouse_coords.y = -screen_space_mouse_coords.y;
		
	float perspective = 0.45;
	vec3 rayOrigin = vec3(screen_space_coords.xy, 0.0) - cameraPos;
	mat3 rotation = axis_y_rotation_matrix(screen_space_mouse_coords.x);
	rotation *= axis_x_rotation_matrix(screen_space_mouse_coords.y);
	vec3 view_direction = normalize(vec3(screen_space_coords.x * perspective, screen_space_coords.y * perspective, 1.0));
	vec3 rayDir = normalize(view_direction);
	rayOrigin *= rotation;
	rayDir *= rotation;
	  
	vec3 position = vec3(0.0);
	int objectID = -1;
	bool intersection = trace(rayOrigin, rayDir, position);
	
	if (intersection) { // hit
		gl_FragColor = ApplyMaterial(objectID, position, rayOrigin, rayDir);
	}
	else { // background
		gl_FragColor = ApplyBackground(position, rayDir);
	}
}