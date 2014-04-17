#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = gl_FragCoord.xy / resolution.xy - vec2(0.6, 0.0);

	float color = 0.0;
	color += sin(time);
	color += sin(gl_FragCoord.x / 100.0 + time);
	color += sin((gl_FragCoord.x + gl_FragCoord.y) / 100.0 + time);
	vec2 z = vec2(0.0);
	vec2 tmp;
	for (int i = 0; i < 32; i++) {
		tmp.x = z.x * z.x - z.y * z.y + position.x;
		tmp.y = 2.0 * z.x * z.y + position.y;
		z = tmp;
	}
	if (z.x * z.x + z.y * z.y < 0.00000001) color += 0.5;
	
	gl_FragColor = vec4(color);

}