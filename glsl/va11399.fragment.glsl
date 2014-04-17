#ifdef GL_ES
precision highp float;
#endif
 
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

float random(vec3 scale, float seed)
{
	return fract(sin(dot(gl_FragCoord.xyz + seed, scale)) * 43758.5453 + seed);
}

vec3 randomDir(float seed)
{
	float u = random(vec3(12.9898, 78.233, 151.7182), seed);
	float v = random(vec3(63.7264, 10.873, 623.6736), seed);
	float z = 1.0 - 2.0 * u;
	float r = sqrt(1.0 - z * z);
	float angle = 6.283185307179586 * v;
	return vec3(r * cos(angle), r * sin(angle), z);
}

/*
vec2 distfunc(vec3 p)
{
	float d_sphere = max(0.0, length(p - vec3(-1.0, 0, 0)) - 1.5);
	float d_planeX = abs(abs(p.x) - 9.0);
	float d_planeY = abs(abs(p.y) - 8.0);
	float d_planeZ = abs(abs(p.z) - 7.0);
	vec2 d = vec2(d_sphere, 0);
	if(d_planeX < d.x) d = vec2(d_planeX, 1);
	if(d_planeY < d.x) d = vec2(d_planeY, 2);
	if(d_planeZ < d.x) d = vec2(d_planeZ, 3);
	return d;
}

vec3 getnormal(vec3 p, float obj)
{
	float eps = 0.01;
	vec2 d0 = distfunc(p);
	return normalize(vec3(
		distfunc(p + vec3(eps, 0, 0)).x,
		distfunc(p + vec3(0, eps, 0)).x,
		distfunc(p + vec3(0, 0, eps)).x) - d0.x);
}

vec3 trace(vec3 pos, vec3 dir)
{
	float dist = 0.0;
	for(int i = 0; i < 40; i++)
	{
		vec2 d = distfunc(pos + dir * dist);
		if(d.x < 0.01)
			return vec3(dist, d.y, float(i) / 40.0);
		dist += d.x;
	}
	return vec3(10000.0, -1, 1.0);
}
*/

void sphere(float matindex, vec3 p, vec3 d, float r, vec3 p0, inout float min_t, inout float mat, inout vec3 norm)
{
	// |p+d*t-c|^2 = R^2
	// |p-c|^2 + 2*dot(p-c, d)*t + dot(d, d)*t^2 - R^2 = 0
	p -= p0;
	float a = dot(d, d);
	float b = dot(p, d);
	float c = dot(p, p) - r * r;
	float det = b * b - a * c;
	if(det < 0.0 || a == 0.0)
		return;
	det = sqrt(det);
	float t1 = (-b - det) / a;
	float t2 = (-b + det) / a;
	float t = (t1 < t2 && t1 >= 0.0) ? t1 : t2;
	if(t > 0.0 && t < min_t)
	{
		min_t = t;
		mat = matindex;
		norm = normalize(p + d * t);
	}
}

void plane(float matindex, vec3 p, vec3 d, float dist, vec3 n, inout float min_t, inout float mat, inout vec3 norm)
{
	// p0 = n * dist
	// dot(p+d*t - p0, n) = 0
	// dot(p-p0, n) = -t dot(d, n)
	// t = dot(p0-p, n) / dot(d, n)
	// t = dot(n*dist-p, n) / dot(d, n)
	// t = (dist - dot(p, n)) / dot(d, n)
	float t = (dist - dot(p, n)) / dot(d, n);
	if(t > 0.0 && t < min_t)
	{
		min_t = t;
		mat = matindex;
		norm = n;
	}
}

vec2 trace(vec3 p, vec3 d, out vec3 n)
{
	float min_t = 100000.0, mat = -1.0;
	plane (0.0, p, d, 7.0, vec3( 1.0,  0.0,  0.0), min_t, mat, n);
	plane (1.0, p, d, 7.0, vec3(-1.0,  0.0,  0.0), min_t, mat, n);
	plane (2.0, p, d, 6.0, vec3( 0.0,  1.0,  0.0), min_t, mat, n);
	plane (2.0, p, d, 6.0, vec3( 0.0, -1.0,  0.0), min_t, mat, n);
	plane (2.0, p, d, 9.0, vec3( 0.0,  0.0,  1.0), min_t, mat, n);
	plane (2.0, p, d, 9.0, vec3( 0.0,  0.0, -1.0), min_t, mat, n);
	sphere(3.0, p, d, 3.5, vec3( 0.0,  0.0,  0.0), min_t, mat, n);
	return vec2(min_t, mat);
}

vec4 getmaterial(vec3 p, vec3 n, float obj)
{
	if(obj == 0.0) return vec4(1.0, 0.5, 0.5, 0.0);
	if(obj == 1.0) return vec4(0.5, 1.0, 0.5, 0.0);
	if(obj == 2.0) return vec4(0.7, 0.7, 0.7, 0.0);
	if(obj == 3.0) return vec4(1.0, 1.0, 0.5, 1.0);
	return vec4(0, 0, 0, 0);
}

float occlusion(vec3 pos, vec3 dir, vec3 lightpos)
{
	vec3 lightdir = lightpos - pos, hitnorm;
	float l = length(lightdir);
	lightdir /= l;
	vec2 hit = trace(pos, lightdir, hitnorm);
	return (hit.y < 0.0 || hit.x > l) ? max(0.0, -dot(dir, lightdir)) : 0.0;
}

vec3 cosineWeightedDirection(float seed, vec3 normal)
{
	float u = random(vec3(12.9898, 78.233, 151.7182), seed);
	float v = random(vec3(63.7264, 10.873, 623.6736), seed);
	float r = sqrt(u);
	float angle = 6.283185307179586 * v;
	vec3 sdir, tdir;
	if (abs(normal.x) < 0.5)
		sdir = cross(normal, vec3(1, 0, 0));
	else
		sdir = cross(normal, vec3(0, 1, 0));
	tdir = cross(normal, sdir);
	return r * cos(angle) * sdir + r * sin(angle) * tdir + sqrt(1.0 - u) * normal;
}

void main(void)
{
//	gl_FragColor = vec4(0);
//	return;
	
	float seedacc1 = sin(time * 0.0013 + gl_FragCoord.x * 0.023);
	float seedacc2 = sin(time * 0.0017 + gl_FragCoord.y * 0.017);
	float t = sin(2.0 * time) * 0.0;
	float seed = 0.01 * time + gl_FragCoord.x * 1.3;
	vec3 dir0 = vec3(vec2(1.0, 1.2) * (gl_FragCoord.xy * 2.0 - resolution.xy) / resolution.y, 1.0);
	dir0 = normalize(vec3(dir0.x, cos(t) * dir0.y - sin(t) * dir0.z, sin(t) * dir0.y + cos(t) * dir0.z));
	vec3 lightpos = vec3(sin(time * 0.031) * 3.0, 5, sin(time * 0.051) * 3.0), sample = vec3(0);
	for(int n = 0; n < 10; n++)
	{
		vec3 diff = vec3(0.1), dir = dir0, norm, pos = vec3(sin(time * 0.07) * 3.0, sin(time * 0.05) * 3.0, -4.0 + sin(time * 0.03)) + 0.01 * randomDir(seed += seedacc1);
		for(int b = 0; b < 5; b++)
		{
			vec2 hit = trace(pos, dir, norm);
			if(hit.y >= 0.0)
			{
				pos += dir * hit.x;
				vec4 mat = getmaterial(pos, norm, hit.y);
				vec3 rdir = (mat.w == 1.0) ? reflect(dir, norm) : cosineWeightedDirection(seed += seedacc2, -norm);
				diff *= mat.xyz;
				sample += diff * occlusion(pos - norm * 0.001, dir + (cosineWeightedDirection(seed += seedacc2, dir) - dir) * 0.3, lightpos);
				dir = rdir;
			}
		}
	}
	vec4 old = texture2D(backbuffer, gl_FragCoord.xy / resolution.xy);
	gl_FragColor = old + 0.1 * (vec4(sample, 1.0) - old);
}
