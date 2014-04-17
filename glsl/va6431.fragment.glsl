#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec3 blue = vec3(0.0, 0.0, 1.0);
	vec3 green = vec3(0.0, 1.0, 1.0);
	gl_FragColor = vec4(mix(blue, green, gl_FragCoord.s / resolution.x), 0.0);
	
}