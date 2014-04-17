#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define ITERATIONS 10

vec4 f(vec3 pos) {
	vec3 center = vec3(0.5, 0.5, -1);
	float size = 0.2;
	
	vec3 dist = abs(pos - center);
	if (dist.x < size && dist.y < size && dist.z < size) {
		return vec4(1.0, 0.0, 0.0, 0.1);
	} else {
		return vec4(0.0);
	}
	
	return vec4(1.0);
}

void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	vec3 pos = vec3(position, 0.0);
	vec3 dir = vec3(0, 0, -0.1);
	
	vec4 color;
	for (int i = 0; i < ITERATIONS; i++) {
		vec4 voxColor = f(pos);
		gl_FragColor = voxColor;
		
		color = color.a * color + voxColor.a * (1.0 - color.a) * voxColor;
		pos += dir;
	}
	
	gl_FragColor = color;
}