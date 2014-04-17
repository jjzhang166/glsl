#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 pos = gl_FragCoord.xy / resolution.xy;
	float col = 1.0;
	
	float n = sin(time + pos.y * 10.0);
	col *= 0.9 + 0.1 * sign(n) * floor(abs(n) + 0.98);
	
	col *= 0.6 + 0.4 * 16.0 * pos.x * pos.y * (1.0 - pos.x) * (1.0 - pos.y);
	
	col *= 0.8 + 0.2 * sin(5.0 * time - gl_FragCoord.y * 8.0);
	
	gl_FragColor = vec4(col, 0.0, 0.0, 1.0);
}