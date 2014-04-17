#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
float m = min(resolution.x, resolution.y);

void main(void)
{
	vec2 position = gl_FragCoord.xy / m - vec2(0.5 * resolution.x / m, 0.5 * resolution.y / m);
	vec2 point = vec2(cos(time), sin(time));
	float c = 0.0;
	//c += 0.001 / pow(distance(position, point / 3.0), 2.0);
	//c += 0.001 / pow(distance(position, -point / 3.0), 2.0);
	c += 0.01 / abs(position.x * point.y - position.y * point.x);
	c += 0.01 / abs(position.x * point.x + position.y * point.y);
	gl_FragColor = vec4(c * (0.5 + position.y), c * 0.5, c * (0.5 - position.y), 1.0);
}
