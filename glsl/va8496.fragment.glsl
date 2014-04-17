#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	float pi = 3.141;
	float period = resolution.x / 10.0;
	vec3 position = vec3(gl_FragCoord.xy - resolution / 2.0, 1.0);
	float wave = 50.0 * cos(position.x / period * 2.0 * pi);
	float s = sin(time);
	float c = cos(1.732 * time);
	mat3 matrix = mat3(c, s, 0.0, -s, c, 0.0, 1000.0 * sin(2.236 * time), wave, 1.0);
	position = matrix * position;
	float x = position.x;
	float y = position.y;
	float b0 = abs(y) + abs(0.5 * x) - 500.0;
	float b1 = abs(y) - 700.0 * abs(sin(1.414 * time));
	float inner = step(b0, .0) * step(b1, .0);
	gl_FragColor = vec4(step(inner, .5) + inner * 0.9, step(inner, .5) , step(inner, .5) + inner * 0.3, 1.0);
}