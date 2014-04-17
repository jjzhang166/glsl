#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main(void)
{
	vec2 position = (gl_FragCoord.xy - 0.5 * resolution) / min(resolution.x, resolution.y);
	vec2 point = vec2(cos(time * 0.001), sin(time));
	float c = 0.0;
	//c += 0.001 / pow(distance(position, point / 3.0), 2.0);
	//c += 0.001 / pow(distance(position, -point / 3.0), 2.0);
	c += 0.01 / abs(position.x * point.y - position.y * point.x);
	c += 0.01 / abs(position.x * point.x + position.y * point.y);
	gl_FragColor = vec4(c * (0.5 + position.y), c * 0.5, c * (0.5 - position.y), 0.1);
}

