#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 pos = ( gl_FragCoord.xy / resolution.xy );
	vec3 col = vec3(0.0);
	float y = pos.y + sin(pos.x * 10.0) * 0.02 + sin(pos.x * 3.0) * 0.03 - pow(pow(cos(pos.x - 3.5), 200.0) + pow(cos(pos.x - 3.7), 900.0), sin(pos.x * 32.0 + 1.0) * 0.02) * 0.2;
	float rad = mouse.x * 0.35;
	float az = mouse.y * 0.5;
	if (y > 0.2) {
		vec2 xp = gl_FragCoord.xy / resolution.xx;
		float d = distance(xp, vec2(0.5, az));
		if (d < rad)
			col = vec3(1.0);
		else
			col = vec3(rad + 1.0 - d * 0.2 + 0.05, rad - d * 0.35 + 0.05, rad - 0.1 - d * 0.3 + 0.05) * 10.0 * 0.5;
		col += pow(max((0.3- y * 0.2) * 3.0, 0.0), 4.0) * (1.0 - az);
	}
	gl_FragColor = vec4(col, 1.0);
}