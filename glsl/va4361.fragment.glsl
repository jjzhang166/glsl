#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void )
{
	vec3 color = vec3(0.0);
	gl_FragColor = vec4(color, 1.0);
}