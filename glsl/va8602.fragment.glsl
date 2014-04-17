//
// Simple GLSL ray - triangle intersector!
// by @syoyo
//
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

struct Ray
{
  vec3 org;
  vec3 dir;
};

struct Isect
{
  float t;
  float u;
  float v;
  int   tid;
};

int rayTriangleIsect(
  out Isect isect,
  Ray ray,
  vec3 v0,
  vec3 v1,
  vec3 v2)
{
	const float kEPS = 0.001;
	
	vec3 e1 = v1 - v0;
	vec3 e2 = v2 - v0;
	
	vec3 p = cross(ray.dir, e2);
	
	float det = dot(e1, p);
	
	if (abs(det) < kEPS) { // no-cull mode
		return -1;
	}
	
	float inv_det = 1.0 / det;
	vec3 s = ray.org - v0;
	vec3 q = cross(s, e1);
	
	float u = dot(s, p) * inv_det;
	float v = dot(q, ray.dir) * inv_det;
	float t = dot(e2, q) * inv_det;

	bool mask = (u >= 0.0) && (u <= 1.0) && (v >= 0.0) && (u + v <= 1.0) && (t >= 0.0); // && (t <= prevT);
	
	if (mask) {
		// hit!
		isect.t = t;
		isect.u = u;
		isect.v = v;
		isect.tid = 0; // @todo
		return 1;
	}
	
	return 0;
}
	
void main( void ) {

	vec2 position = -1.0 + 2.0 * ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;

	vec3 v0 = vec3(-0.5, -0.5, -1.0);
	vec3 v1 = vec3(0.1, 0.75, -1.0);
	vec3 v2 = vec3(0.5, -0.75, -1.0);
	
	Ray ray;
	ray.org = vec3(position.x, position.y, 0.0);
	ray.dir = normalize(vec3(0.0, 0.0, -1.0));

	Isect isect;
	int hit = rayTriangleIsect(isect, ray, v0, v1, v2);
	vec3 col = vec3(0, 0, 0);

	if (hit > 0) {
		col.x = isect.u;
		col.y = isect.v;
		col.z = isect.t;
	}
		
	gl_FragColor = vec4( col, 1.0);
	
}