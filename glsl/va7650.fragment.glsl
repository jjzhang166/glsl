// made by cheery @ http://boxbase.org/

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 ray_box_intersection(vec3 origin, vec3 direction, vec3 dim, vec3 pos) {
	// contribution by http://codeflow.org/
	vec3 boxMin = pos-dim;
	vec3 boxMax = pos+dim;
	vec3 fmin = (boxMin-origin)/direction;
	vec3 fmax = (boxMax-origin)/direction;
	vec3 axisMax = max(fmin, fmax);
	vec3 axisMin = min(fmin, fmax);
	float entry = max(max(axisMin.x, axisMin.y), axisMin.z);
	float exit = min(min(axisMax.x, axisMax.y), axisMax.y);
	float intersected = step(entry, exit);
	return vec3(entry, exit, intersected);
}

#define PI 3.14159265359

vec3 rotate_y(vec3 p, vec2 cs) {
	return vec3(p.x*cs.x - p.z*cs.y, p.y, p.x*cs.y + p.z*cs.x);
}
vec3 rotate_x(vec3 p, vec2 cs) {
	return vec3(p.x, p.y*cs.x - p.z*cs.y, p.y*cs.y + p.z*cs.x);
}

void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xy ) - 0.5;
	float aspect = resolution.x / resolution.y;
	float x_fov = 160.0 / 360.0 * PI;
	float y_fov = 1.0;
	
	vec3 origin = vec3(0.0, 0.0, -3.0);
	vec3 direction = vec3(
		sin(position.x*x_fov+sin(time+position.x*10.0)*0.2),
		sin(position.y*y_fov),
		cos(position.x*x_fov)*cos(position.y*y_fov)
	);
	
	float p = 1.0 * sin(time*1.2);
	vec2 cs0 = vec2(cos(p), sin(p));
	vec2 cs1 = vec2(cos(time), sin(time));
	origin = rotate_y(rotate_x(origin, cs0), cs1);
	direction = rotate_y(rotate_x(direction, cs0), cs1);	
	
	vec3 hit = ray_box_intersection(origin, direction, vec3(1.0,1.0,1.0), vec3(0.0));
	if (hit.z == 0.0) discard;
	vec3 color = vec3(0.0);
	float t = hit.x;
	float influence = 1.0;
	float transparency = 0.9;
	for (int i = 0; i < 50; i++) {
		vec3 point = (origin + direction*t);
		color += (point / 2.0 + 0.5)*influence*(1.0-transparency);
		influence *= transparency;
		t += 0.05;
		if (t > hit.y) break;
	}
	
	gl_FragColor = vec4(color, 1.0);
}