#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main() {
	float radius = (sin(time)+5.0)*10.0;
	vec2 LightIndex = floor((gl_FragCoord.xy + vec2(radius)) / vec2(2.0 * radius + 1.0 ));
	vec2 LightPos = LightIndex * vec2(2.0 * radius + 1.0 );
	
	float intensity = 1.0 - (distance(gl_FragCoord.xy, LightPos) / float(radius));
	
	vec3 color = vec3(abs(sin(time)), 0.8, abs(sin(time+1.6)));
	vec3 FinalColor = color * vec3(intensity);
	gl_FragColor = vec4(FinalColor, 1.0);
}