#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec4 torus(float r, float R, float u, float v) {
	float x = (R + r * cos(v)) * cos(u);
	float y = (R + r * cos(v)) * sin(u);
	float z = r * sin(v);
	float w = 1.0;
	return vec4(x, y, z, w);
}

float distObj(vec3 point, vec4 obj) {
	float xs = (point.x - obj.x) * (point.x - obj.x);
	float ys = (point.y - obj.y) * (point.y - obj.y);
	float zs = (point.z - obj.z) * (point.z - obj.z);
	
	return sqrt(xs + ys + zs);
}

void main( void ) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	
	vec3 us = vec3(uv, 0.0);
	vec4 torus = torus(0.01, 0.01, 1.0, 1.0);
	
	float dist = distObj(us, torus);
	
	gl_FragColor = vec4(vec3(dist), 1.0);

}