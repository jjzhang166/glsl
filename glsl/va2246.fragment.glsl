#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
#define pi 3.1415927410125

void main()
{
	vec2 pos = gl_FragCoord.xy / resolution - mouse;
	pos.x *= (resolution.x / resolution.y);
	
	float u = length(pos);
	float v = atan(pos.y, pos.x);
	float t = time / 5.0 + 1.0 / u;
	
	float intensity = abs(sin(t * 10.0 + v)) * .25 * u * 0.25;
	vec3 col = vec3(abs(sin(time)), abs(sin(time + pi / 3.0)), abs(sin(time - pi / 3.0))) * 16.0;
	
	gl_FragColor = vec4(col * intensity, 1.0);
}