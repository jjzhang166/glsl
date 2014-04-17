#ifdef GL_ES
	precision mediump float;
#endif

// Uniform Variable
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

struct Ray
{
	vec3 origin;
	vec3 direction;
};

struct Camera
{
	vec3 position;
};

struct Light
{
	vec3 position;
	vec3 color;
};

struct Material
{
	vec3 color;
};

struct Sphere
{
	vec3 position;
	float radius;
	Material material;
};

struct Plane
{
	vec3 normal;
	vec3 point;
	Material material;
};

// Scene Object
Camera camera;
Light light;
Sphere sphere;
Plane plane;
Plane plane2;

// Final Color
vec3 finalColor = vec3(0.0, 0.0, 0.0);

// Initialize Scene
void initScene(void)
{
	camera.position = vec3(0.0, 0.0, 1.0);

	light.position = vec3(0.3, 0.3, -0.3);
	light.color = vec3(1.0, 1.0, 1.0);

	sphere.position = vec3(0.0, 0.0, 0.0);
	sphere.radius = 0.25;
	sphere.material.color = vec3(0.3, 0.6, 0.2);

	plane.normal = vec3(0.0, 1.0, 0.0);
	plane.point = vec3(0.0, -0.2, 0.0);
	plane.material.color = vec3(0.9, 0.1, 0.1);

	plane2.normal = vec3	(1.0, 0.0, -1.0);
	plane2.point = vec3(0.0, 0.0, 0.2);
	plane2.material.color = vec3(0.0, 0.1, 0.9);
}

// Update Scene
void updateScene(void)
{
	sphere.position.y = 0.1 * sin(time * 3.0);
}

float intersectSphere(Sphere s, Ray r)
{
	vec3 v = r.origin - s.position;

	float a = dot(r.direction, r.direction);
	float b = dot(2.0 * v, r.direction);
	float c = dot(v, v) - s.radius * s.radius;

	float disc = b * b - 4.0 * a * c;
	if(disc < 0.0)
	{
		return -1.0;
	}

	float temp = sqrt(disc) / 4.0*a;

	float t1 = -b - temp;
 	float t2 = -b + temp;

	if(t1 < 0.0)
	{
		return t2;
	}
	else if(t2 < 0.0)
	{
		return t1;
	}

	return min(t1, t2);
}

float intersectPlane(Plane p, Ray r)
{
	float NdotD = dot(p.normal, r.direction);

	if(NdotD == 0.0)
	{
		return -1.0;
	}

	return dot(p.normal, p.point - r.origin) / NdotD;
}

// Render Scene
void renderScene(void)
{
	vec2 pixel = (gl_FragCoord.xy - resolution / 2.0) / resolution;
	vec2 aspectRatio = vec2(resolution.x / resolution.y, 1.0);

	Ray ray;
	ray.origin = camera.position;
	ray.direction = normalize(vec3(vec3(pixel, 0.0) - camera.position) * vec3(aspectRatio, 1.0));

	float t;
	int obj = 0;
	float t1 = intersectSphere(sphere, ray);
	float t2 = intersectPlane(plane, ray);
	float t3 = intersectPlane(plane2, ray);
	if(t1 > 0.0)
	{
		t = t1;
		obj = 1;
	}
	else if(t2 > 0.0)
	{
		t = t2;
		obj = 2;
	}
	else if(t3 > 0.0)
	{
		t = t3;
		obj = 3;
	}

	if(obj == 1)
	{
		vec3 point = ray.origin + t * ray.direction;
		vec3 normal = normalize(point - sphere.position);
		float d = length(point - light.position);
		float NL = max(dot(normal, normalize(light.position)), 0.0);

		vec3 diffuse = sphere.material.color * light.color * NL / (1.5 * d);

		finalColor = diffuse;
	}
	else if(obj == 2)
	{
		vec3 point = ray.origin + t * ray.direction;
		vec3 normal = normalize(plane.normal);
		float d = length(point - light.position);
		float NL = max(dot(normal, normalize(light.position)), 0.0);

		vec3 diffuse = plane.material.color * light.color * NL / (1.5 * d);

		finalColor = diffuse;
	}
	else if(obj == 3)
	{
		vec3 point = ray.origin + t * ray.direction;
		vec3 normal = normalize(plane2.normal);
		float d = length(point - light.position);
		float NL = max(dot(normal, normalize(light.position)), 0.0);

		vec3 diffuse = plane2.material.color * light.color * NL / (1.5 * d);

		finalColor = diffuse;
	}
	else
	{
		finalColor = vec3(0.0, 0.0, 0.0);
	}
}

void main(void)
{
	initScene();

	updateScene();

	renderScene();

	gl_FragColor = vec4(finalColor, 1.2);
}
