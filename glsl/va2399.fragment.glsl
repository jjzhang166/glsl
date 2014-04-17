#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	float a = resolution.y / resolution.x;
	uv.x /= a;
	uv.x -= 1.5 * a;
	float b = -mod(time * 5.0, 0.2);
	vec2 r = vec2(0.5);
	uv.x = r.x + cos(b) * (uv.x - r.x) - sin(b) * (uv.y - r.y);
	uv.y = r.y + sin(b) * (uv.x - r.x) + cos(b) * (uv.y - r.y);
	
	vec2 s = uv;
	
	float intensity = 0.0;
	if (s.x > 0.25 && s.x < 0.75 && s.y > 0.25 && s.y < 0.75) {
		intensity = 1.0;
	}
	
	vec3 color = vec3(intensity);
	
	if (mod(time * 5.0, 0.1) < 0.05) {
		color = 1.0 - color;
	}
	
	gl_FragColor = vec4(color, 1.0);
}