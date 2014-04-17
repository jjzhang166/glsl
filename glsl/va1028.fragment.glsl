/* tentacles from the deep; by josh */

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 position = (gl_FragCoord.xy - resolution * 0.5) / resolution.yy;
	float th = atan(position.y, position.x*2.0) / (0.4 * 3.1415926) + 0.5 + time/5.0;
	float dd = length(position);
	float d = 0.25 / dd + time*2.0 + mouse.y;

	vec3 uv = vec3(th + d, th - d, th + sin(d) * 0.1);
	float c = 0.5 + cos(uv.z * 3.1415926 * 6.0) * 0.5;
	vec3 color = mix(vec3(0.9, 0.8, 1.0), vec3(0.1, 0.2, 0.5),  pow(c, 0.1)) * 0.75;
	gl_FragColor = vec4(color * clamp(dd, 0.0, 1.0), 1.0);
}