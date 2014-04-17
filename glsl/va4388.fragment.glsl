precision highp float;

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float cutoff = 0.4;
const float height = 0.2;
const float radius = 0.2;
const vec4 color = vec4(1.0, 1.0, 1.0, 1.0);

void main()
{
	vec3 light = vec3(mouse, height);
	vec3 position = vec3(gl_FragCoord.xy / resolution.xy, 0.0);
	
	float L = length(light - position);
	float d = clamp(L - radius, 0.0, cutoff);

	float f = d / cutoff;
	d /= 1.0 - f * f;
	
	d = d / radius + 1.0;
	float attenuation = 1.0 / (d * d);
	
	float normal = max(light.z / L, 0.0);
	gl_FragColor = color * normal * attenuation;
}