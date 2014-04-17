#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main() {
	int radius = 15;
	vec2 LightIndex = floor((gl_FragCoord.xy + vec2(radius)) / vec2(2 * radius + 1 ));
	vec2 LightPos = LightIndex * vec2(2 * radius + 1 );
	
	float intensity = 1.0 - (distance(gl_FragCoord.xy, LightPos) / float(radius));
	
	vec3 color = vec3(0.0, 1.0, 0.0);
	vec3 FinalColor = color * vec3(intensity);
	gl_FragColor = vec4(FinalColor, 1.0);
}