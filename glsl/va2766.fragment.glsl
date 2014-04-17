#ifdef GL_ES
precision lowp float;
#endif

uniform vec2 resolution;
void main(void) 
{
	vec2  p = gl_FragCoord.xy / resolution.xy - vec2(0.5, 0.5);
	p.y *= resolution.y / resolution.x;

	float col = clamp((length(p) - 0.12) * 1000.0, 0.0, 1.0);
	gl_FragColor = vec4(1.0, col, col, 1.0);
}