#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 pos = (gl_FragCoord.xy - resolution.xy / 2.0) / 200.0;

	float color = 0.0;
	float x = -pos.x;
	float y = -pos.y;
	if(x < 1.0 && x > -1.0 && y < 1.0 && y > -1.0) {
		float e = sqrt(3.0 * x * x + 2.0 * x * y - 4.0 * x + 3.0 * y * y - 4.0 * y + 2.0) + x + y - 1.0;
		if(length(pos) < 1.0) color = pow(1.0 - e, 2.0) * (sin(e * 31.415926 - time * 8.0) / 2.0 + 0.5);
	} else {
		color = mod(floor(gl_FragCoord.x / 8.0) + floor(gl_FragCoord.y / 8.0), 2.0) == 1.0 ? 0.9 : 1.0;
	}
	gl_FragColor = vec4(vec3(color), 1.0);
}