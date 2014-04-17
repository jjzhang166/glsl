#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;
const float PI = 3.141592653589793;

// ported from https://github.com/evanw/webgl-path-tracing
// by @erucipe

// modified by @h013

vec3 eye = vec3(0.0, 0.0, 2.5);
float glossiness = 0.6;
vec3 roomCubeMin = vec3(-1.0, -1.0, -1.0);
vec3 roomCubeMax = vec3(1.0, 1.0, 1.0);
vec3 light = vec3(0.4, 0.5, -0.6);
vec3 sphereCenter = vec3(0.0, 0.0, 0.0);
float sphereRadius = 0.25;

vec2 intersectCube(vec3 origin, vec3 ray, vec3 cubeMin, vec3 cubeMax) {
	vec3 tMin = (cubeMin - origin) / ray;
	vec3 tMax = (cubeMax - origin) / ray;
	vec3 t1 = min(tMin, tMax);
	vec3 t2 = max(tMin, tMax);
	float tNear = max(max(t1.x, t1.y), t1.z);
	float tFar = min(min(t2.x, t2.y), t2.z);
	return vec2(tNear, tFar); 
}

vec3 normalForCube(vec3 hit, vec3 cubeMin, vec3 cubeMax) {
	if(hit.x < cubeMin.x + 0.0001) 
		return vec3(-1.0, 0.0, 0.0);
	else if(hit.x > cubeMax.x - 0.0001)
		return vec3(1.0, 0.0, 0.0);
	else if(hit.y < cubeMin.y + 0.0001)
		return vec3(0.0, -1.0, 0.0);
	else if(hit.y > cubeMax.y - 0.0001)
		return vec3(0.0, 1.0, 0.0);
	else if(hit.z < cubeMin.z + 0.0001)
		return vec3(0.0, 0.0, -1.0);
	else 
		return vec3(0.0, 0.0, 1.0); 
}

float intersectSphere(vec3 origin, vec3 ray, vec3 sphereCenter, float sphereRadius) {
	vec3 toSphere = origin - sphereCenter;
	float a = dot(ray, ray);
	float b = 2.0 * dot(toSphere, ray);
	float c = dot(toSphere, toSphere) - sphereRadius*sphereRadius;
	float discriminant = b*b - 4.0*a*c;
	if(discriminant > 0.0) {
		float t = (-b - sqrt(discriminant)) / (2.0 * a);
		if(t > 0.0) return t;   
	}
	return 10000.0;
}

vec3 normalForSphere(vec3 hit, vec3 sphereCenter, float sphereRadius) {
	return (hit - sphereCenter) / sphereRadius; 
}

float random(vec3 scale, float seed) {
	return fract(sin(dot(gl_FragCoord.xyz + seed, scale)) * 43758.5453 + seed); 
}


vec3 cosineWeightedDirection(float seed, vec3 normal) {
	float u = random(vec3(12.9898, 78.233, 151.7182), seed);
	float v = random(vec3(63.7264, 10.873, 623.6736), seed);
	float r = sqrt(u);   float angle = 6.283185307179586 * v;
	vec3 sdir, tdir;   if (abs(normal.x)<.5) {
		sdir = cross(normal, vec3(1,0,0));   
	}
	else {
		sdir = cross(normal, vec3(0,1,0));   
	}
	tdir = cross(normal, sdir);
	return r*cos(angle)*sdir + r*sin(angle)*tdir + sqrt(1.-u)*normal; 
}

vec3 uniformlyRandomDirection(float seed) {
	float u = random(vec3(12.9898, 78.233, 151.7182), seed);
	float v = random(vec3(63.7264, 10.873, 623.6736), seed);
	float z = 1.0 - 2.0 * u;
	float r = sqrt(1.0 - z * z);
	float angle = 6.283185307179586 * v;
	return vec3(r * cos(angle), r * sin(angle), z); 
}

vec3 uniformlyRandomVector(float seed) {
	return uniformlyRandomDirection(seed) * sqrt(random(vec3(36.7539, 50.3658, 306.2759), seed)); 
}

float shadow(vec3 origin, vec3 ray) {
	float tSphere = intersectSphere(origin, ray, sphereCenter, sphereRadius);
	if(tSphere < 1.0)
		return 0.0;
	return 1.0; 
}

vec3 calculateColor(vec3 origin, vec3 ray, vec3 light) {
	vec3 colorMask = vec3(1.0);
	vec3 accumulatedColor = vec3(0.0);
	for(int bounce = 0; bounce < 5; bounce++) {
		vec2 tRoom = intersectCube(origin, ray, roomCubeMin, roomCubeMax);
		float tSphere = intersectSphere(origin, ray, sphereCenter, sphereRadius);
		float t = 10000.0;
		if(tRoom.x < tRoom.y) t = tRoom.y; if(tSphere < t) t = tSphere;
		vec3 hit = origin + ray * t;
		vec3 surfaceColor = vec3(0.75);
		float specularHighlight = 0.0;
		vec3 normal;
		if(t == tRoom.y) {
			normal = -normalForCube(hit, roomCubeMin, roomCubeMax);
			if(hit.x < -0.9999) 
				surfaceColor = vec3(0.1, 0.9, 0.1);
			else if(hit.x > 0.9999)
				surfaceColor = vec3(0.9, 0.1, 0.1);
			ray = cosineWeightedDirection(time + float(bounce), normal);
		}
		else if(t == 10000.0) {
			break;
		} 
		else {
			if(false) ; 
			else if(t == tSphere) 
				normal = normalForSphere(hit, sphereCenter, sphereRadius);
			ray = normalize(reflect(ray, normal)) + uniformlyRandomVector(time + float(bounce)) * glossiness;
			vec3 reflectedLight = normalize(reflect(light - hit, normal));
			specularHighlight = max(0.0, dot(reflectedLight, normalize(hit - origin))); specularHighlight = pow(specularHighlight, 3.0);
		}
		vec3 toLight = light - hit;
		float diffuse = max(0.0, dot(normalize(toLight), normal));
		float shadowIntensity = shadow(hit + normal * 0.0001, toLight);
		colorMask *= surfaceColor;
		accumulatedColor += colorMask * (0.5 * diffuse * shadowIntensity);
		accumulatedColor += colorMask * specularHighlight * shadowIntensity;
		origin = hit;
	}
	return accumulatedColor;
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

void main( void ) {
	vec2 uv = gl_FragCoord.xy / resolution;
	vec3 rd = normalize( vec3( (uv * 2.0 - 1.0) * vec2(resolution.x / resolution.y, 1.0), -1.0) );
	
	mat3 rotation = axis_y_rotation_matrix((1.0 - mouse.x * 2.0) * PI);
	rotation *= axis_x_rotation_matrix((mouse.y * 2.0 - 1.0) * PI);
	
	eye *= rotation;
	rd *= rotation;
	
	vec3 newLight = light + uniformlyRandomVector(time - 53.0) * 0.1;
	//gl_FragColor = vec4(calculateColor(eye, rd, newLight), 1.0);
	vec4 prev = texture2D(backbuffer, uv);
	vec3 now = calculateColor(eye, rd, newLight);
	gl_FragColor = vec4(mix(prev.xyz, now, 6.0/255.0), 1.0);
}