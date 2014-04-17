#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec3 color = vec3(floor(mod(time*60.0,2.0)));
	gl_FragColor = vec4(color, 1.0);
}