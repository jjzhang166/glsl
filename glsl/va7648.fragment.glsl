#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 ray_box_intersection(vec3 origin, vec3 direction, vec3 dim, vec3 pos) {
	vec3 boxMin = pos-dim;
	vec3 boxMax = pos+dim;
	vec3 fmin = (boxMin-origin)/direction;
	vec3 fmax = (boxMax-origin)/direction;
	vec3 axisMax = max(fmin, fmax);
	vec3 axisMin = min(fmin, fmax);
	float entry = max(max(axisMin.x, axisMin.y), axisMin.z);
	float exit = min(min(axisMax.x, axisMax.y), axisMax.z);
	float intersected = step(entry, exit);
	return vec3(entry, exit, intersected);
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
	
	vec3 hit = ray_box_intersection(origin, direction, vec3(1.0,1.0,1.0), vec3(0.0));
	vec3 color = ((origin + direction*hit.x) / 2.0 + 0.5) * hit.z;
	gl_FragColor = vec4(color, 1.0);
}