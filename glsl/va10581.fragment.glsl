#ifdef GL_ES
precision highp float;
#endif

uniform float time;

void main(void) {
	float r =  sin(time*6.0) * 0.15;
	float g =  cos(time*6.0) * 0.15;
	float b = 1.0;
	gl_FragColor = vec4(r,g,b,1.0);
}