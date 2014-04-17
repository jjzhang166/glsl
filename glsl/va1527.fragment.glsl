//Polar coordinate thingie by @simplyianm

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define PI 3.1415926
#define EPSILON 0.01

//Cartesian to polar coords
vec2 cartopol(vec2 car) {
	float r = sqrt(car.x * car.x + car.y * car.y);
	float theta = atan(car.y, car.x);
	return vec2(r, theta);
}

//Polar to cartesian coords
vec2 poltocar(vec2 pol) {
	float x = pol.x * cos(pol.y);
	float y = pol.x * sin(pol.y);
	return vec2(x, y);
}

//Polar distance
float dist(vec2 pol, vec2 center) {
	return sqrt(pol.x * pol.x - 2.0 * pol.x * center.x * cos(pol.y - center.y) + center.x * center.x);
}

void main( void ) {
	vec2 scaled = gl_FragCoord.xy / resolution.xy;
	
	float aspect = resolution.x / resolution.y;
	
	//Center the graph
	vec2 uv = scaled;
	uv.y /= aspect;
	uv.x -= 0.5;
	uv.y -= 0.5 / aspect;
	
	vec2 pol = cartopol(uv);
	
	vec3 color = vec3(0.0);
	
	float petals = 15.0;
	
	float radius = abs(sin(time)) / 4.0;
	
	float rose = radius * cos(petals * (pol.y - mod(time, PI / (petals / 2.0))) + 100.0);
	
	if (rose > pol.x - EPSILON && rose < pol.x + EPSILON) {
		color = vec3(1.0);
	}
	
	gl_FragColor = vec4(color, 1.0);
}