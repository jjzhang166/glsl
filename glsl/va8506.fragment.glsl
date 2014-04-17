#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	float pi = 3.1416;
	float period = 1000.0;
	vec3 position = vec3(gl_FragCoord.xy, 1.0);
	float wave = 50.0 * cos(position.x / period * 2.0 * pi);
	float s = sin(time);
	float c = cos(time);
	mat3 matrix = mat3(c, s, 0.0, -s, 1.0, 0.0, 1000.0 * s, wave, 1.0);
	position = matrix * position;
	float x = position.x;
	float y = position.y;
	float flag = step(mod(x, period), period / 2.0) + step(mod(y, 300.0), 300.0 / 2.0);
	gl_FragColor = vec4(1.0, 1.0, flag, 1.0);
}