#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float PI = 3.14159265358979323846264;
vec3 lightPosition = vec3(100.0, 200.0, 500.0);
vec3 eye = vec3(0.0, 200.0, 500.0);

float square(float value) {
	return value * value;
}

vec4 muster(vec2 pos) {
	return vec4(sin(pos.x * 200.0) * sin(pos.y / 10.0), 1.0, 1.0, 1.0);
}

float saturate(float value) {
	return clamp(value, 0.0, 1.0);	
}

float calcRadius(vec2 pos, vec2 f1, vec2 f2, float ellipseConstant) {
	float bruch = (square(ellipseConstant) + square(distance(pos, f1))
		       - square(distance(pos, f2))) / (2.0 * ellipseConstant);
	return square(bruch) - square(distance(pos, f1));
}

void main() {
	vec2 position = gl_FragCoord.xy;

	gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
	
	vec2 center = vec2(550.0, 200.0);
	vec2 f1 = center + vec2(0.0, -100.0);
	vec2 f2 = center + vec2(0.0, 100.0);
	
	lightPosition.x = sin(time) * 1000.0;
	lightPosition.y = sin(time * 0.5) * 2000.0;
	
	if (distance(position, f1) + distance(position, f2) < 245.0) {
		float radius = calcRadius(position, f1, f2, 245.0);
		float winkel = asin(abs(position.x - center.x) / radius);
		
		float z = radius * cos(winkel);
		z = sqrt(square(radius) - square(position.x - center.x));
		z *= 0.01;
		vec3 world = vec3(position, z);
		vec3 normal = normalize(world - vec3(center, 0.0));
		vec3 lightDirection = normalize(world - lightPosition);
		//lightDirection = vec3(0.1, 0.2, -0.7);
		float diffuse = saturate(dot(normal, -lightDirection));
		vec3 h = normalize(normalize(eye - world) - lightDirection);
		float specular = pow(saturate(dot(h, normal)), 150.0);
		float light = 0.4 + diffuse * 0.5;
		
		if (position.x < center.x) winkel = PI / 2.0 - winkel;
		else winkel += PI / 2.0;
		gl_FragColor = muster(vec2(winkel - time / 100.0, position.y)) * light + specular;
		//gl_FragColor = vec4(diffuse, 0.0, 0.0, 1.0);
		//gl_FragColor = vec4(normal, 1.0);
	}
}