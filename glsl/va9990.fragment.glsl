// by @301z

precision highp float;

uniform sampler2D backbuffer;
uniform float time;
uniform vec2 resolution;

struct Ray {
	vec3 origin;
	vec3 direction;
};

struct Sphere {
	vec4 positionRadius;
	vec4 colorEmission;
	int reflectionType;
};

struct Hit {
	Sphere sphere;
	float distance;
};

const int kSamplesPerPixel = 9000;
const int kSamplesPerFrame = 30;

const float kTwoPI = 2.0 * 3.14159;
const float kInf = 1e20;

const int kDiffuse = 0;
const int kSpecular = 1;
const int kRefraction = 2;

const Sphere kLeft = Sphere(vec4(1e4 + 1.0, 40.8, 81.6, 1e4), vec4(0.75, 0.25, 0.25, 0.0), kDiffuse);
const Sphere kRight = Sphere(vec4(-1e4 + 99.0, 40.8, 81.6, 1e4), vec4(0.25, 0.25, 0.75, 0.0), kDiffuse);
const Sphere kBack = Sphere(vec4(50.0, 40.8, 1e4, 1e4), vec4(0.75, 0.75, 0.75, 0.0), kDiffuse);
const Sphere kFront = Sphere(vec4(50.0, 40.8, -1e4 + 170.0, 1e4), vec4(0.0), kDiffuse);
const Sphere kBottom = Sphere(vec4(50.0, 1e4, 81.6, 1e4), vec4(0.75, 0.75, 0.75, 0.0), kDiffuse);
const Sphere kTop = Sphere(vec4(50.0, -1e4 + 81.6, 81.6, 1e4), vec4(0.75, 0.75, 0.75, 0.0), kDiffuse);
const Sphere kMirror = Sphere(vec4(27.0, 16.5, 47.0, 16.5), vec4(0.999, 0.999, 0.999, 0.0), kSpecular);
const Sphere kGlass = Sphere(vec4(73.0, 16.5, 78.0, 16.5), vec4(0.999, 0.999, 0.999, 0.0), kRefraction);
const Sphere kLight = Sphere(vec4(50.0, 81.6 - 15.0, 81.6, 7.0), vec4(0.0, 0.0, 0.0, 12.0), kDiffuse);

Hit intersect(Hit hit, Ray ray, Sphere sphere) {
	vec3 op = sphere.positionRadius.xyz - ray.origin;
	float b = dot(op, ray.direction);
	float d = b * b - dot(op, op) + sphere.positionRadius.w * sphere.positionRadius.w;
	float ds = sqrt(d);
	Hit newHit = Hit(sphere, b + sign(ds - b) * ds);
	return all(bvec3(d > 0.0, newHit.distance > 0.01, newHit.distance < hit.distance)) ? newHit : hit;
}

Hit intersect(Ray ray) {
	Hit hit = Hit(kLight, kInf);
	hit = intersect(intersect(intersect(hit, ray, kLeft), ray, kRight), ray, kBack);
	hit = intersect(intersect(intersect(hit, ray, kFront), ray, kBottom), ray, kTop);
	hit = intersect(intersect(intersect(hit, ray, kMirror), ray, kGlass), ray, kLight);
	return hit;
}

vec3 cosineWeightedDirection(float u, float v, vec3 normal) {
	float r = sqrt(u);
	float angle = kTwoPI * v;
	vec3 sdir = cross(normal, (abs(normal.x) < 0.5) ? vec3(1.0, 0.0, 0.0) : vec3(0.0, 1.0, 0.0));
	vec3 tdir = cross(normal, sdir);
	return r * cos(angle) * sdir + r * sin(angle) * tdir + sqrt(1.0 - u) * normal;
}

float random(vec3 scale, float seed) {
	return fract(sin(dot(gl_FragCoord.xyz + seed, scale)) * 43758.5453 + seed);
}

vec3 radiance(Ray ray, float seed) {
	vec3 color = vec3(0.0);
	vec3 reflectance = vec3(1.0);
	for (int depth = 0; depth < 5; depth++) {
		Hit hit = intersect(ray);
		if (!(hit.distance < kInf))
			break;
		seed += float(depth);
		color += reflectance * hit.sphere.colorEmission.w;
		reflectance *= hit.sphere.colorEmission.xyz;
		vec3 hitPosition = ray.origin + ray.direction * hit.distance;
		vec3 hitNormal = (hitPosition - hit.sphere.positionRadius.xyz) / hit.sphere.positionRadius.w;
		bool bInto = dot(hitNormal, ray.direction) < 0.0;
		vec3 normal = bInto ? hitNormal : -hitNormal;
		const float kNC = 1.0;
		const float kNT = 1.5;
		vec3 reflection = reflect(ray.direction, normal);
		vec3 refraction = refract(ray.direction, normal, bInto ? (kNC / kNT) : (kNT / kNC));
		if (hit.sphere.reflectionType == kDiffuse)
			ray = Ray(hitPosition, cosineWeightedDirection(random(hitPosition, seed), random(normal, seed), normal));
		else if (any(bvec2(hit.sphere.reflectionType == kSpecular, !any(bvec3(refraction)))))
			ray = Ray(hitPosition, reflection);
		else {
			const float kR0 = (kNT - kNC) * (kNT - kNC) / ((kNT + kNC) * (kNT + kNC));
			float c = 1.0 - (bInto ? -dot(ray.direction, normal) : dot(refraction, -normal));
			float Re = kR0 + (1.0 - kR0) * c * c * c * c * c;
			float P = 0.25 + 0.5 * Re;
			if (random(refraction, seed) < P) {
				reflectance = reflectance * Re / P;
				ray = Ray(hitPosition, reflection);
			} else {
				reflectance = reflectance * (1.0 - Re) / (1.0 - P);
				ray = Ray(hitPosition + refraction * 0.01, refraction);
			}
		}
	}
	return color;
}

vec3 radiance(float seed) {
	Ray camera = Ray(vec3(50.0, 52.0 - 1.0, 295.6), normalize(vec3(0.0, -0.042612, -1.0)));
	vec3 cx = vec3(0.5135 * resolution.x / resolution.y, 0.0, 0.0);
	vec3 cy = 0.5135 * normalize(cross(cx, camera.direction));
	vec2 uv = (gl_FragCoord.xy + vec2(random(cx, seed), random(cy, seed)) * 2.0 - 1.0) / resolution - 0.5;
	vec3 d = camera.direction + cx * uv.x + cy * uv.y;
	return radiance(Ray(camera.origin + d * 140.0, normalize(d)), seed);
}

vec3 pmain(float seed) {
	vec3 color = vec3(0.0);
	for (int i = 0; i < kSamplesPerFrame; i++)
		color += radiance(seed + float(i));
	color *= (1.0 / float(kSamplesPerFrame));
	return color;
}

vec2 encodeNumber(float n) {
	float y = floor(n * (1.0 / 256.0));
	return vec2(n - y * 256.0, y) * (1.0 / 255.0);
}

float decodeNumber(vec2 n) {
	return (n.y * 256.0 + n.x) * 255.0;
}

vec4 encodeColor(vec3 n) {
	n = min(n, 1.0);
	float d = max(n.x, max(n.y, n.z));
	return vec4(n / d, d);
}

vec3 decodeColor(vec4 n) {
	return n.xyz * n.w;
}

void main() {
	const float kLoop = float(kSamplesPerPixel / kSamplesPerFrame);
	vec4 state = texture2D(backbuffer, vec2(0.0));
	state = ((state.z + state.w) > 0.0) ? vec4(0.0) : state;
	float samples = decodeNumber(state.xy);
	float samplesNext = min(samples + 1.0, kLoop);
	state = vec4(encodeNumber(samplesNext), 0.0, 0.0);
	vec4 color = texture2D(backbuffer, gl_FragCoord.xy / resolution.xy);
	if (samples < kLoop) {
		color.xyz = mix(pmain(time + samples), decodeColor(color), samples / samplesNext);
		color = (samplesNext < kLoop) ? encodeColor(color.xyz) : vec4(pow(color.xyz / (color.xyz + vec3(1.0)), vec3(1.0 / 2.2)), 1.0);
	}
	gl_FragColor = ((gl_FragCoord.x + gl_FragCoord.y) < 8.0) ? state : color;
}