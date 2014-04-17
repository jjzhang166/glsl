#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 position = gl_FragCoord.xy / resolution.xy * 2. - 1.;
	position.x *= resolution.x / resolution.y;
	vec3 c = vec3 (0.);
	
	gl_FragColor = vec4 (c, 1.);
}