#ifdef GL_ES
precision lowp float;
#endif

uniform vec2 resolution;
void main(void) {
	vec2  p = gl_FragCoord.xy / resolution.xy - vec2(0.5, 0.5);
	p.y *= resolution.y / resolution.x;
	gl_FragColor = vec4(1, 1, 1, 1);
	
	if (length(p) < 0.15) {
		gl_FragColor = vec4(8, 0, 0, 0);
	}
}