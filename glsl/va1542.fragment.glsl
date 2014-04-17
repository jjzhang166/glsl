#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	float aspect = resolution.x / resolution.y;
	uv.y /= aspect;
	
	if (mod(distance(vec2(0.5, 0.5), uv), 1.0) > 0.1) {
		gl_FragColor = vec4(vec3(1.0), 1.0);	
	}
}