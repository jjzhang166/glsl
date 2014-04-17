#ifdef GL_ES
precision mediump float;
#endif

uniform float time;

void main()
{
	gl_FragColor = vec4(0.35*time, 0.5, 0.75, 1.0);
}
