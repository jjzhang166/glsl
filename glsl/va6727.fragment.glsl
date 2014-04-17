#ifdef GL_ES
precision mediump float;
#endif

uniform float time;

void main(void)
{
	float r, g, b;

	r = 0.0;
	g = 0.0;
	b = 0.0;
	
	gl_FragColor = vec4(r, g, b, 1.0);
}