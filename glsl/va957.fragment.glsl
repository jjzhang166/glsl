#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	
	vec2 p = -1.0 + 2.0 * gl_FragCoord.xy / resolution;
	vec2 z = p + 0.2 + mouse * 1.0;
	
	vec2 c = vec2(-0.745, sin(time * 0.1));
	float t = 0.0;
	for (int i = 0; i < 64; ++i) {
		vec2 nz = vec2( z.x * z.x - z.y * z.y, 2.0 * z.x * z.y) + c;
		float m2 = dot(nz, nz);
		if (m2 > 4.0) break;
		z = nz;
		t += 1.0 / 63.0;
	}
	vec3 col = vec3(t, smoothstep(0.2, 1.0, t), t * t);
	gl_FragColor = vec4(col, 1.);
}