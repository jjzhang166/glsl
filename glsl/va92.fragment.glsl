#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

int inPaddle(vec2 pos, vec2 o, vec2 dim) {
	vec2 min = o - dim * 0.5, max = o + dim * 0.5;
	if(pos.x >= min.x && pos.x <= max.x && pos.y >= min.y && pos.y <= max.y)
		return 1;
	return 0;
}

float tent(float t) {
	t = mod(t, 8.0);
	return (t > 1.0 ? 2.0 - t : t);
}

void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	float t = tent(time * 0.5), t2 = tent(time * 0.67);
	vec2 paddle = vec2(t, 0.05);
	vec2 size = vec2(0.05, 0.02);
	float radius = 0.01 + sin(time) * 0.005;
	vec2 ball = vec2(t, t2 * (1.0 - 2.0 * (paddle.y - radius)) + paddle.y + radius);
	vec2 ball2 = (mouse - position) * 0.04 + ball * 0.96;
	vec2 d = position - ball;
	vec2 d2 = position - ball2;

	vec4 back = vec4(t + sin(mouse.x), t2 + sin(mouse.y), (t + t2) * 0.5, 1) * 0.25;

	if(inPaddle(position, paddle, size) == 1)
		gl_FragColor = vec4(1, 1, 1, 1);
	else if(dot(d,d) < radius * radius) {
		t = (1.0 - dot(d,d) / (radius * radius));
		gl_FragColor = vec4(1.0, 0.4, 0.5, 1) * t + back * (1.0 - t);
	} else if(dot(d2,d2) < radius * radius) {
		t = (1.0 - dot(d2,d2) / (radius * radius));
		gl_FragColor = vec4(0.1, 0.2, 0.0, 1) * t + back * (1.0 - t);
	} else
		gl_FragColor = back;
}