#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	vec3 r0 = vec3(0.0, 11.0, 4.0); //the position of view
	vec3 rd = vec3((-1.0 + 2.0 * uv) * vec2(1.78, 1.0), -1.0);
	gl_FragColor = vec4(rd,1.0);
}