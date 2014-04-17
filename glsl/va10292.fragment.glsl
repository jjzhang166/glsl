#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	float dist = distance(gl_FragCoord.xy, mouse * resolution);
	dist /= resolution.x;
	vec3 color = (0.2 / dist) * vec3(mouse, 1.0);
	gl_FragColor = vec4(color, 1.0);
}