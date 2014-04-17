#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

varying vec2 surfacePosition;

float cube1Width = 0.5;
vec3 cube1DiffuseColor = vec3(0.7, 0.5, 0.9);
vec3 cube1SpecularColor = vec3(0.8, 0.5, 0.1);
float cube1Shininess = 16.0;

mat3 plane1Faces = mat3(
	0.0, -0.5, 0.0,
	0.0, -0.5, 1.0,
	1.0, -0.5, 0.0
);
vec3 plane1DiffuseColor = vec3(0.6, 0.7, 0.9);
vec3 plane1SpecularColor = vec3(1.0, 0.8, 0.1);
float plane1Shininess = 1.0;

vec3 light1Position = vec3(0.0, 1.0, -1.2);
float light1Attenuation = 0.4;

vec3 ambientColor = vec3(0.0, 0.05, 0.05);
vec3 backgroundColor = ambientColor;//vec3(0.3);

float focalLength = 0.5;


#define PI_2 6.283185307179586
#define INFINITY 1e10

void createCube(float width, mat4 worldTransform, out mat3 faces[6]) {
	float halfWidth = width / 2.0;
	vec3 vertices[8];
	vertices[0] = (worldTransform * vec4(-halfWidth, -halfWidth, -halfWidth, 1.0)).xyz;
	vertices[1] = (worldTransform * vec4(-halfWidth, -halfWidth, halfWidth, 1.0)).xyz;
	vertices[2] = (worldTransform * vec4(-halfWidth, halfWidth, -halfWidth, 1.0)).xyz;
	vertices[3] = (worldTransform * vec4(-halfWidth, halfWidth, halfWidth, 1.0)).xyz;
	vertices[4] = (worldTransform * vec4(halfWidth, -halfWidth, -halfWidth, 1.0)).xyz;
	vertices[5] = (worldTransform * vec4(halfWidth, -halfWidth, halfWidth, 1.0)).xyz;
	vertices[6] = (worldTransform * vec4(halfWidth, halfWidth, -halfWidth, 1.0)).xyz;
	vertices[7] = (worldTransform * vec4(halfWidth, halfWidth, halfWidth, 1.0)).xyz;
	
	faces[0] = mat3(vertices[0], vertices[4], vertices[1]);
	faces[1] = mat3(vertices[2], vertices[3], vertices[6]);
	faces[2] = mat3(vertices[0], vertices[1], vertices[2]);
	faces[3] = mat3(vertices[4], vertices[6], vertices[5]);
	faces[4] = mat3(vertices[0], vertices[2], vertices[4]);
	faces[5] = mat3(vertices[1], vertices[5], vertices[3]);
}

float intersect(mat3 vertices, vec3 rayOrigin, vec3 rayDirection, bool isPlane, bool isParallelogram, out vec3 normal) {
	vec3 triangleOrigin = vertices[0];
	
	vec3 O_tr = rayOrigin - triangleOrigin;

	vec3 u = vertices[1] - vertices[0];
	vec3 v = vertices[2] - vertices[0];
	normal = cross(u, v);
	
	float n_dot_r = dot(normal, rayDirection);
	
	if (n_dot_r == 0.0) {
		return INFINITY;
	}
	
	float I_r = - dot(normal, O_tr) / n_dot_r;
	float I_u = dot(cross(O_tr, v), rayDirection) / n_dot_r;
	float I_v = dot(cross(u, O_tr), rayDirection) / n_dot_r;
	
	if (I_r >= 0.0 && (
		isPlane || (
			0.0 <= I_u && I_u <= 1.0 &&
	    		0.0 <= I_v && I_v <= 1.0 && (
				isParallelogram || I_u + I_v <= 1.0
			)
		)
	)) {
		return I_r;
	} else {
		return INFINITY;
	}
}

float intersectTriangle(mat3 vertices, vec3 rayOrigin, vec3 rayDirection, out vec3 normal) {
	return intersect(vertices, rayOrigin, rayDirection, false, false, normal);
}

float intersectParallelogram(mat3 vertices, vec3 rayOrigin, vec3 rayDirection, out vec3 normal) {
	return intersect(vertices, rayOrigin, rayDirection, false, true, normal);
}

float intersectPlane(mat3 vertices, vec3 rayOrigin, vec3 rayDirection, out vec3 normal) {
	return intersect(vertices, rayOrigin, rayDirection, true, false, normal);
}

float intersectCube(mat3 faces[6], vec3 rayOrigin, vec3 rayDirection, out vec3 normal) {
	float depth = INFINITY;
	normal = vec3(0.0);
	for (int i = 0; i < 6; i++) {
		vec3 n;
		float depthTemp = intersectParallelogram(faces[i], rayOrigin, rayDirection, n);
		if (depthTemp < depth) {
			depth = depthTemp;
			normal = n;
		}
	}
	return depth;
}

void main( void ) {
	float angleX = -mouse.y * PI_2;
	float angleY = mouse.x * PI_2;
	mat4 rotX = mat4(
		1.0, 0.0, 0.0, 0.0,
		0.0, cos(angleX), -sin(angleX), 0.0,
		0.0, sin(angleX), cos(angleX), 0.0,
		0.0, 0.0, 0.0, 1.0
	);
	mat4 rotY = mat4(
		cos(angleY), 0.0, -sin(angleY), 0.0,
		0.0, 1.0, 0.0, 0.0,
		sin(angleY), 0.0, cos(angleY), 0.0,
		0.0, 0.0, 0.0, 1.0
	);
	
	mat4 cubeTransform = rotX * rotY;
	
	vec3 rayOrigin = vec3(surfacePosition, -1.0);
	vec3 rayDirection = normalize(vec3(rayOrigin.x, rayOrigin.y, focalLength));
	
	mat3 cube1Faces[6];
	createCube(cube1Width, cubeTransform, cube1Faces);
	vec3 cubeNormal;
	float cubeDepth = intersectCube(cube1Faces, rayOrigin, rayDirection, cubeNormal);
	
	vec3 planeNormal;
	float planeDepth = intersectPlane(plane1Faces, rayOrigin, rayDirection, planeNormal);
	
	vec3 color = backgroundColor;
	
	float depth;
	vec3 normal;
	vec3 diffuseColor;
	vec3 specularColor;
	float shininess;
	bool castShadow;
	if (planeDepth < cubeDepth) {
		depth = planeDepth;
		normal = planeNormal;
		diffuseColor = plane1DiffuseColor;
		specularColor = plane1SpecularColor;
		shininess = plane1Shininess;
		castShadow = true;
	} else {
		depth = cubeDepth;
		normal = cubeNormal;
		diffuseColor = cube1DiffuseColor;
		specularColor = cube1SpecularColor;
		shininess = cube1Shininess;
		castShadow = false;
	}
	
	if (depth < INFINITY) {
		light1Position = vec3(
			cos(time) + light1Position.x,
			light1Position.y,
			sin(time) + light1Position.z
		);
		
		vec3 vertexPosition = rayOrigin + rayDirection * depth;
		normal = normalize(normal);
		vec3 vertexToLight = light1Position - vertexPosition;
		float dist = length(vertexToLight);
		vertexToLight = normalize(vertexToLight);
		
		bool isShadow = false;
		if (castShadow) {
			vec3 n;
			if (intersectCube(cube1Faces, vertexPosition, vertexToLight, n) < INFINITY) {
				isShadow = true;
				color = ambientColor;
			}
		}
		
		if (!isShadow) {
			float attenuation = 1.0 / (light1Attenuation * dist * dist);
			float diffuseTerm = attenuation * max(0.0, dot(normal, vertexToLight));
			float specularTerm =  attenuation * pow(max(0.0, dot(normalize(reflect(-vertexToLight, normal)), -rayDirection)), shininess);
			
			color = ambientColor + diffuseColor * diffuseTerm + specularColor * specularTerm;
		}
	}
	
	gl_FragColor = vec4(color, 1.0);

}