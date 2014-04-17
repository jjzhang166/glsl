#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 rotate(float angle, vec2 p) {
	vec2 t = vec2(0.0);
	t.x = p.x * cos(-angle) - p.y * sin(-angle);
	t.y = p.y * cos(-angle) + p.x * sin(-angle);

	return t;
}

vec2 repeatOver(vec2 shift, vec2 p) {
	return mod(p, shift) - 0.5 * shift;
}

bool inSquare(float size, vec2 p) {
	return abs(p.x) < (size + 0.02 * sin(15.0 * 3.14 * p.y + time)) && abs (p.y) < (size);
}

bool inScene(vec2 p) {
	vec2 repeatedPoint = repeatOver(vec2(0.3), p);
	vec2 t = rotate(1.7 * time, repeatedPoint * 3.0);
	return inSquare(0.2 + 0.02 * cos(time), t);
}

void main( void ) {

	vec2 q = gl_FragCoord.xy / resolution.xy;
	vec2 p = -1.0 + 2.0*q;

	if (resolution.x > resolution.y)
		p.x *= resolution.x / resolution.y;
	else
		p.y *= resolution.y / resolution.x;


	
	float color =  inScene(p) ? 1.0: 0.0;
	float gradient = color * 1.0 - length(p);
	if (gradient < 0.0) gradient = 0.0;
	gl_FragColor = vec4(vec3(gradient * (1.0 - p.x), 0.0, gradient * (1.0 - p.y)), 1.0);

}