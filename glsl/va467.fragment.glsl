#ifdef GL_ES
precision lowp float;
#endif

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;

void main(void) {
	vec2 half_res = resolution.xy / 2.0;
	float time20 = time * 0.01;
	
	//float a1 = distance(half_res * (1.0 + sin(time20 * vec2(19 + 1, 2 * 19 + 1))), gl_FragCoord.xy);
	float a1 = distance(mouse*resolution.xy, gl_FragCoord.xy);
	float b1 = distance(half_res * (1.0 + sin(time20 * vec2(20 + 1, 2 * 20 + 1))), gl_FragCoord.xy);
	float c1 = distance(half_res * (1.0 + sin(time20 * vec2(24 + 1, 2 * 24 + 1))), gl_FragCoord.xy);
	float d1 = distance(half_res * (1.0 + sin(time20 * vec2(25 + 1, 2 * 25 + 1))), gl_FragCoord.xy);
	float c = (float(d1 / c1 > b1 / a1))/1000.0;
	
	gl_FragColor = vec4(c*a1, c*b1, c*d1, 1.0);
}