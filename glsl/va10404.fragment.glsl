#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main() {
	
	float x = gl_FragCoord.x / resolution.x;
	float y = gl_FragCoord.y / resolution.y;
	
	float r = sin(x + y + time/5.0) * asin(x / 0.2*time) / cos (0.2*time) / sin(x * y);
	
	float g = sin(r) * sin(-r) + cos(time * y/x) - sin(x*0.2*time/y);
	
	float b = cos(r * g) / cos(g*x/y);
	
	vec3 sum = vec3(r, g, b);
	
	gl_FragColor = vec4(sum.x, sum.y, sum.z, 1);
}