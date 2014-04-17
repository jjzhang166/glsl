#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main(void)
{
	vec2 position = (gl_FragCoord.xy / resolution.xy) - 0.5;

	vec3 color;
	color.r = cos(sqrt(pow(position.x + mouse.x - 0.5, 2.0) + pow(position.y - mouse.y + 0.5, 2.0)) * 200.0 - time * 3.0);
	color.g = cos(sqrt(pow(position.x, 2.0) + pow(position.y, 2.0)) * 200.0 - time * 3.0);
	color.b = cos(sqrt(pow(position.x - mouse.x + 0.5, 2.0) + pow(position.y + mouse.y - 0.5, 2.0)) * 200.0 - time * 3.0);
	gl_FragColor = vec4(color, 1.0);
}