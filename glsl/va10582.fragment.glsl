#ifdef GL_ES
precision highp float;
#endif

uniform float time;

void main(void) {
	float r = 0.2 + sin(time*6.26) * 0.15;
	float g = 0.3 + cos(time*6.28) * 0.15;
	float b = 0.4*time;
	gl_FragColor =  vec4(r,g,b,1.0);
}