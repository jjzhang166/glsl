#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec3 color;
	float t = resolution.x;
	color = vec3(sin(t), sin(t*0.3), sin(t*0.2))*0.5 + 0.5;
	gl_FragColor = vec4(color, 1.0 );

}