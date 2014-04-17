#ifdef GL_ES
precision mediump float;
#endif
uniform vec2 resolution;
uniform vec2 mouse;
void main( void ) {
	vec2 position = gl_FragCoord.xy / resolution.xy;
	float color = cos(position.x * 40.0) + cos(position.y * 40.0);
	gl_FragColor = vec4(vec3(mouse.x, position.x, cos((gl_FragCoord.y - resolution.y / 2.) / mouse.y / 10.)), 1.);
}