#ifdef GL_ES Fork by Harley
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main()
{

	vec2 position = -1.0 + 2.0 * (gl_FragCoord.xy / resolution.xy);
	position.x *= resolution.x / resolution.y;
	position += vec2(sin(time * 1.25), sin(time * 1.25)) * 0.6;
	vec3 colour = vec3(1.6);
	float u = sqrt(dot(position, position));
	float v = atan(position.y, position.x);
	float t = time - 2.0 / v+u;
	float val = smoothstep(0.2, 4.0, sin(115.0 * (time + sin(78999.0*t * t)) + 942.0 * v) + cos(t * 0.0));
	colour = vec3(val / 0.1, val, 0.0) + (1.9 - val) * vec3(0.15, 0.15, 0.15);
	colour *= clamp(u / 1.0, 0.0, 1.0);
	gl_FragColor = vec4(colour, 1.0);
}