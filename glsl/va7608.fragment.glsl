#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float PI = 3.141592;
vec2 adjustAspectRatio( vec2 v) {
	return v * vec2(resolution.x / resolution.y, 1.0) + vec2(-resolution.y / resolution.x * 0.5, 0.0);
}

float makePattern(float n, float m, float r, vec2 position, vec2 center, float phase) {
	float c = 0.0;
	vec2 v = position - center;
	float theta = atan(v.y, v.x);
	float t = (theta + PI) / (PI * 2.0) + phase;
	float d = distance(position, center);
	c = cos(t * PI * n + r * sin(d * PI * m));
	//c = c > 0.0 ? 1.0 : 0.0;
	return c;
}

void main( void ) {
	vec2 position = adjustAspectRatio( gl_FragCoord.xy / resolution.xy );
	float c = 0.0;
	vec2 center = adjustAspectRatio(vec2(0.5, 0.5));
	float c1 = makePattern(100.0, 5.0, 2.0, position, center, time * 0.01);
	float c2 = makePattern(50.0, 5.0, 1.0, position, adjustAspectRatio(mouse), 0.0);
	c = max(pow(c1 + c2 - c1 * c2, 0.01), 0.0);
	vec3 color1 = vec3(1.0, 0.8, 0.0);
	vec3 color2 = vec3(0.2, 1.0, 0.5);
	vec3 color = mix(color1, color2, c);
	
	gl_FragColor = vec4( color, 1.0 );

}