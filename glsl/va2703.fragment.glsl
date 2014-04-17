#ifdef GL_ES
precision lowp float;
#endif

uniform vec2 resolution;
void main(void) {
	vec2 p = (gl_FragCoord.xy / resolution.xy);
	gl_FragColor = vec4(1, 1, 1, 1);
	if (-p.x + 1.0 > p.y) gl_FragColor = vec4(0, 0, 1, 1);
	if (p.y < 0.5) {
		gl_FragColor = vec4(1, 0, 0, 1);
		if (p.x < p.y) gl_FragColor = vec4(0, 0, 1, 1);
	}
}