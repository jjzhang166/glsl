#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 ray_box_intersection(vec3 origin, vec3 direction, vec3 dim, float t0) {
	vec3 inv_d = 1.0 / direction;
	vec3 s = sign(inv_d);
	vec3 tmin = (-dim*s - origin) * inv_d;
	vec3 tmax = (+dim*s - origin) * inv_d;
	if ( (tmin.x > tmax.y) || (tmin.y > tmax.x) ) return vec3(0.0);
	if ( tmin.y > tmin.x ) tmin.x = tmin.y;
	if ( tmax.y < tmax.x ) tmax.x = tmax.y;
	if ( (tmin.y > tmax.z) || (tmin.z > tmax.x) ) return vec3(0.0);
	if ( tmin.z > tmin.x ) tmin.x = tmin.z;
	if ( tmax.z < tmax.x ) tmax.x = tmax.z;
	return vec3(tmin.x, tmax.x, 1.0);
}

#define PI 3.14159265359

void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xy ) - 0.5;
	float aspect = resolution.x / resolution.y;
	float x_fov = 160.0 / 360.0 * PI;
	float y_fov = 1.0;
	
	vec3 origin = vec3(sin(time)*3.0, cos(time)*3.0, -8.0);
	vec3 direction = vec3(
		sin(position.x*x_fov),
		sin(position.y*y_fov),
		cos(position.x*x_fov)*cos(position.y*y_fov)
	);
	
	vec3 hit = ray_box_intersection(origin, direction, vec3(1.0,1.0,1.0), 0.0);
	vec3 color = ((origin + direction*hit.x) / 2.0 + 0.5) * hit.z;
	gl_FragColor = vec4(color, 1.0);
}