#ifdef GL_ES
precision highp float;
#endif

uniform vec3 resolution;
uniform float time;


void main(void)
{
	vec3 col = vec3(0.5);
	
	gl_FragColor = vec4(col, 1.0);
}