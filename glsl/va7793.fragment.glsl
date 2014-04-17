// set ^^^^ to 1 or anything but 2

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
float PI = acos(-1.0);

void main(void)
{
	vec2 position = (gl_FragCoord.xy / resolution.xy) - 0.5;
	float angle = PI + atan(position.y / position.x) + sign(position.x) * PI / 2.0;
	float radius = length(position);
	
	angle /= 2.0 * PI;
	float c;

	for (int i = 0; i < 10; i++) {
		c += clamp(1.0 - 10.0 * abs(10.0 * radius - (angle + float(i) - mod(time, 1.0))), 0.0, 1.0);
	}
	gl_FragColor = vec4(c, c, c, 1.0);
}
