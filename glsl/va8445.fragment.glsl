#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float interpolate(float x, float min_x, float max_x) {
	return x * max_x + (1.0 - x) * min_x;
}

float normsin(float x) {
	return (sin(x) + 1.0) / 2.;
}

void main(void) {
	vec2 position = ( gl_FragCoord.xy / resolution.x ) - 0.5;
	position.y *= resolution.y / resolution.x;

	float color = normsin(30. * position.x + interpolate(normsin(25. * position.y + 10.0), 5.0, 25.) + 
			      30. * position.y + interpolate(normsin(25. * position.x + 10.0), 5.0, 25.) + 2. * time);
	gl_FragColor = vec4( (1.0 - color), (1.0 - color) * .5, color, 1.0 );

}