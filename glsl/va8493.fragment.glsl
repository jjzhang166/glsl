#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	float pi = 3.141;
	float g = -1.3;
	float period = resolution.x / 2.0;
	vec3 position = vec3(resolution / 2.0, 1.0);
	float wave = 50.0 * sin(2.0 * time) * cos((gl_FragCoord.x - resolution.x / 2.0) / period * 2.0 * pi);
	mat3 matrix = mat3(1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, wave, 1.0);
	position = matrix * position;
	position.x += 200.0 * sin(3.0 * time);
	float dist = sqrt(pow((gl_FragCoord.x - position.x) / 20.0, 2.0) + pow(gl_FragCoord.y - position.y, 2.0));
  	vec4 color = vec4(1.0, 1.0, 1.0, 1.0);
  	float val = pow(dist, g);
  	color = vec4(val * 0.8 + 0.8, val * 0.5 + 0.8, val * 0.5 + 0.8, 1.0);
  	gl_FragColor = color;
}