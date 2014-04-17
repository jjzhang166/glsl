#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float noise (vec2 coord) {
	return fract(sin(dot(coord.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

/*
vec2 transform (vec2 coord) {
	vec2 scale;
	if (resolution.x > resolution.y) {
		scale.x = resolution.x / resolution.y;
		scale.y = 1.0;
	} else {
		scale.x = 1.0;
		scale.y = resolution.y / resolution.x;
	}
	return (coord / resolution * 2.0 - 1.0) * scale;
}
*/

void main () {
	gl_FragColor = vec4(vec3(1.0, 1.0, 1.0) * pow(noise(vec2(gl_FragCoord) * time), 4.0), 1.0);
}