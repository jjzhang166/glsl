#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float sphere(in vec3 ray_orgin,in vec3 ray_direction) {
	float r = 1.0;
	float b = 2.0 * dot(ray_direction, ray_direction);
	float c = dot(ray_orgin, ray_orgin);
	float h = b * b - 4.0 * c;
	if(h < 0.0) {
		return -1.0;
	}
	float t = -b - sqrt(h) / 2.0;
	return t;
}

float intersect(in vec3 ray_orgin,in vec3 ray_direction) {
	float t = sphere(ray_orgin, ray_direction);
	return t;
}

void main( void ) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	
	//init ray origin and direction
	vec3 ray_orgin = vec3(0.0, 1.0, 0.0);
	vec3 ray_direction = normalize(vec3(-1.0 + 2.0 * uv, -1.0));
	
	//intersects the ray with scene
	float id = intersect(ray_orgin, ray_direction);
	
	//default color black
	vec3 color = vec3(0.0);
	
	//if ray hit something, change color to white
	if(id > 0.0) {
		color = vec3(1.0);	
	}
	gl_FragColor = vec4(color, 1.0 );

}