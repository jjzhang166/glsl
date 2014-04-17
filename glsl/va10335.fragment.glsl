#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main()
{
	gl_FragColor = vec4(1.0, 0.0, 0., 1.0);
}