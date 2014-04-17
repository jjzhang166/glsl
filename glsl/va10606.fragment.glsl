#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float iter = 500.0;
void main () {
	float scale = 4.0;
	float speed = 1.0;
	vec2 center = vec2 (0.5, 0.5);
	
	
	float res = resolution.x / resolution.y;
	vec2 pos = gl_FragCoord.xy / resolution.xy;
	pos.x *= res;
	
	vec2 c = (pos - center) * scale;
	vec2 z = c;
	
	vec2 dist = (pos - center);
	
	gl_FragColor = vec4(0.5 + 0.5 * sin((sqrt(gl_FragCoord.x * gl_FragCoord.x + gl_FragCoord.y * gl_FragCoord.y) + 50.0 * -time) * 0.2), 0.0, 0.0, 1.0);
	for (float i = 0.0; i < iter; i += 1.0) {
		z = vec2(z.x*z.x - z.y*z.y, 2.0*z.x*z.y) + c;
		if (dot(z, z) > 4.0) {
			if (i > 0.0) gl_FragColor = vec4(1, 0.7 + sin(i * time * speed) * 0.3, 0.3 + sin(i * time * speed) * 0.3, 1.0);
			else gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
			break;
		}
		
	}
}